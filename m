Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88DA521CEE
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 19:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbfEQR57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 13:57:59 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:37759 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728225AbfEQR57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 13:57:59 -0400
Received: by mail-pg1-f170.google.com with SMTP id n27so1041920pgm.4
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 10:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GQhTEoubL5u/s5MAGDlSjAkNwB+IrqwkSDi3TLpfhmg=;
        b=gBOFR5daek1qs5dmfIfmaycIC96fXV9DCXEjQnw2KlxeyIlFVbd3/NRZJGwcrcAhpb
         sWAqmRMccodCU/UQpKSmcVxocmUiIVg6ZsTCsfBiFILkYTAie1iWnzInrpfUd5nyevXT
         sWFgCIjF3gRTpUH1dDLWa2TzCeYaivo8qBtubGP7QI6oFkIZNP2cebUhs4rLbkX9Qu7N
         rDddVByT/mzfiBRO78Y5mJPgzLhMJnk/HLsiQ6u5xDaTWZKLBTpGwaZIrqA3kkNc5DF9
         zFHVCmOyflBklZYkT7RK03hCuLCwYjreKjbQdO2ER2t/OuSGou8mD82h5VLA0w8MLzlU
         YZBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GQhTEoubL5u/s5MAGDlSjAkNwB+IrqwkSDi3TLpfhmg=;
        b=E6bKWKewcMffXgw9pCepc24JWaRjTEkWlltvvrEtPiFtP9CvgzTIaQc2KEABV58ivc
         1PS1/ayK4xRTenQhztV+0HDLb0br1ZJBfIioXMzNSpvS1gWqmWlXCl6FolBkrj/8cqju
         UVWdgiWcvzA5DJ0DmjmcH15KIy8Xq75iWRkLfgJPEEF2dD5rlX/TXWtd/xraBj9pgPBu
         tzigcjLfwzD4eX8fFpDqV8N2sV/suQpr//rUp9D3Bg83B5c2KYONnpiSvVS0cUV5TIEc
         XeHo5+OtcMkCUIM45IMsnhZzKxS0rajZRtCr5fGcZuE+++cpxjlAbFowsqFeYt439fwF
         SAhg==
X-Gm-Message-State: APjAAAWI+S0/mvkYD/G2J/JQ6OYv/Fj1cJvhm8moBFwZXy44QLsuxh3G
        w4h8CQkqlENejhkScspsoHSCvw==
X-Google-Smtp-Source: APXvYqxXbFRl7ft/pUxb3WpdkHcwTHlIkKa8DmlmHffbsx2ghqZh0bI9P0mMq/0k425tfZdbi18BiQ==
X-Received: by 2002:a63:1f04:: with SMTP id f4mr58500995pgf.423.1558115878998;
        Fri, 17 May 2019 10:57:58 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k6sm11746366pfi.86.2019.05.17.10.57.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 10:57:58 -0700 (PDT)
Date:   Fri, 17 May 2019 10:57:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Nir Weiner <nir.weiner@oracle.com>, netdev@vger.kernel.org,
        liran.alon@oracle.com
Subject: Re: [iproute2 2/3] tc: jsonify tbf qdisc parameters
Message-ID: <20190517105751.7d5a7907@hermes.lan>
In-Reply-To: <a60c8e21-28bf-294c-7e3d-612493346bbb@gmail.com>
References: <20190506161840.30919-1-nir.weiner@oracle.com>
        <20190506161840.30919-3-nir.weiner@oracle.com>
        <a60c8e21-28bf-294c-7e3d-612493346bbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 May 2019 11:35:16 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 5/6/19 10:18 AM, Nir Weiner wrote:
> 
> >  	if (prate64) {
> > -		fprintf(f, "peakrate %s ", sprint_rate(prate64, b1));
> > +		print_string(PRINT_ANY, "peakrate", "peakrate %s ", sprint_rate(prate64, b1));
> >  		if (qopt->mtu || qopt->peakrate.mpu) {
> >  			mtu = tc_calc_xmitsize(prate64, qopt->mtu);
> >  			if (show_details) {
> >  				fprintf(f, "mtu %s/%u mpu %s ", sprint_size(mtu, b1),
> >  					1<<qopt->peakrate.cell_log, sprint_size(qopt->peakrate.mpu, b2));  
> 
> 
> The fprintf under show_details should be converted as well. This applies
> to patch 1 as well.
> 
> And, please add example output to each patch.

One trick I used was scanning for all calls to fprintf(f and replacing them
