Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD0E221C8E
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 19:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbfEQRfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 13:35:19 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:39280 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728451AbfEQRfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 13:35:19 -0400
Received: by mail-pl1-f170.google.com with SMTP id g9so3647680plm.6
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 10:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DIWndCfk+aQUjakVUo4IgrZ25DQY5Y/41wEuVppCQ0E=;
        b=NXjsHUsVO58r9CzEOKzu9dwRvhnKfOrFLejVgtLh5cik75yRHn8BwZBfl3KCgySIyv
         HkjCpexLkXTqci9rb2Vx+TewNGvNSwpCn1YutiScFm02Gv/eFRy2OMAx8FmhzKnOi0xy
         s0+BPbEGFKpBaRVDxj8tnPIqQJG0FmQBo16sRcTTK7aNb7MQ0BtTH9thKp7miNYAWO85
         FAi90Fd7H7ypoeFr98vbzWA7c/cdtJKJ9j7CRizZoHL8Dx6+dRhpWcAaZnJ60ID7Be4k
         L5/ZvtvWCmRXSNib2iBjbjCIZ+x6ZzAkaame2TmW+nGN3EOztS7QDHFj3goAvElZhnm9
         vkZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DIWndCfk+aQUjakVUo4IgrZ25DQY5Y/41wEuVppCQ0E=;
        b=PRJc3uk8NQnDwNBfqX4WYNqoEEVKzh4/MbzMnJLChkRPUC3jPpZs6tv2PxRZ40KsFJ
         h4AEgNu4/N78JpF75GEOwZSYwx7c8SgnT4fcXxCCwdlqGznjmFtPQLrTYmslNBuLhes7
         gLzF9DH8k7o9svEgqRBWNc15ocXQxNyqdQiAYFuInlySg/CG94lx8eKvAvR1yaVhz1Dk
         b76FJb30JBxRfhkOJUtVzhe+VoRkBoVVQf23aenysQvIXnDrvjJimjGQIoizWmdh6Vq0
         BqJmn9YXYW0toXDxKD/o1XYc9EXUS9v0wvClAnFHX1QVBr92/x8W55SLpHrD1KzuNJd7
         zTHw==
X-Gm-Message-State: APjAAAX4XKS8fI9Eg4cmvhJKAwSpNJcE53mLChWauwJTOwxGMiQey5pR
        LGtJsOx5/VzE5QNz6vW3dyYFp5I8
X-Google-Smtp-Source: APXvYqx/xV4AexvGA0amlY5dhsvb0YWXs6y7yPhXriAAaHz4kN5tF2JNyrxTwj57v+hgm4LWf/P5Fw==
X-Received: by 2002:a17:902:8c82:: with SMTP id t2mr50245117plo.256.1558114518917;
        Fri, 17 May 2019 10:35:18 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:743c:f418:8a94:7ec7? ([2601:282:800:fd80:743c:f418:8a94:7ec7])
        by smtp.googlemail.com with ESMTPSA id k192sm8632715pga.20.2019.05.17.10.35.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 10:35:17 -0700 (PDT)
Subject: Re: [iproute2 2/3] tc: jsonify tbf qdisc parameters
To:     Nir Weiner <nir.weiner@oracle.com>, netdev@vger.kernel.org
Cc:     liran.alon@oracle.com
References: <20190506161840.30919-1-nir.weiner@oracle.com>
 <20190506161840.30919-3-nir.weiner@oracle.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a60c8e21-28bf-294c-7e3d-612493346bbb@gmail.com>
Date:   Fri, 17 May 2019 11:35:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190506161840.30919-3-nir.weiner@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/19 10:18 AM, Nir Weiner wrote:

>  	if (prate64) {
> -		fprintf(f, "peakrate %s ", sprint_rate(prate64, b1));
> +		print_string(PRINT_ANY, "peakrate", "peakrate %s ", sprint_rate(prate64, b1));
>  		if (qopt->mtu || qopt->peakrate.mpu) {
>  			mtu = tc_calc_xmitsize(prate64, qopt->mtu);
>  			if (show_details) {
>  				fprintf(f, "mtu %s/%u mpu %s ", sprint_size(mtu, b1),
>  					1<<qopt->peakrate.cell_log, sprint_size(qopt->peakrate.mpu, b2));


The fprintf under show_details should be converted as well. This applies
to patch 1 as well.

And, please add example output to each patch.
