Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A338F127F58
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfLTPbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:31:42 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54962 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbfLTPbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:31:41 -0500
Received: by mail-wm1-f65.google.com with SMTP id b19so9335765wmj.4
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 07:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8T/hTJRQEUY+pXamoA8E4ONw1BwbW3ESwtdN2r4RaUM=;
        b=NZEtRdI+XzH1OVveJVwqBu9kXcJr3ItCWvM8GEKaZ2iPe6iRed0p3fmfLxPWF/6oIa
         sm0LjySCVRpMediaOFDPkZ5MrZzwhAU9wSn62w0QcO8xZGo56zZHb9LP4v//VXC/3FAa
         0mJKYHzUGvHFZCjvGLQj9Md499Oau/WB/MLM8VtPqqZA4gf4dx7smUgnzs4QrEAWLk5X
         XK7FieWMQugWqzjLUDNZr9tC1W++952jsddnVgZpKmNwNOrC57lfdW9WaLW7dVsQBx58
         0MUaUjB8vyBaDdJWYZUzUXVFX5OuoAtQXnQolMm2lNPkif0baJerHD30MIjXM5pKCQkl
         11vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8T/hTJRQEUY+pXamoA8E4ONw1BwbW3ESwtdN2r4RaUM=;
        b=IcLdasSMOQ/2IM0NbmJLGqJ6R5gI9peJYx7nnV0JJ7sbn0mLw3XDMvJk4Hc44QuNPU
         dC3of4TZ+7eiMY8VhdFUlxmggVMTpaXqvd4PurEVe5n3NmUdsIxDo+iUvalDTmz0q94x
         JrraYcO+F8SOpbJd7e2x9p/sKYe42ZpSmZt4jEs42wCEaj/gTylIhwVgZbH0sYFk/u6I
         MgEUwpmg7FqXM3nxZFmarwuMuwq78v0rxRELZD9PDU15Ipye3+MMeVUXKs2L08nEzgBy
         3RvFUGv8BdhYgfEEo1I5ChMs0+WiASooLQwHYo+0i6n9UnG3SY6eymNVOB73yWQfBFDU
         XonA==
X-Gm-Message-State: APjAAAVcOmMKmeVRgU1w3Ad+RCNxLWC7SQkpPpm3TKIA5ZxvRAZEcEmK
        vKPvYtW9p0SIq13j9NpYNqw=
X-Google-Smtp-Source: APXvYqyx7/xaMO/YkujePuos10l1TNn/eo6DHHipMMg3GY1LvpPH1XEUGgJY1IuT4zcASlzN/33Peg==
X-Received: by 2002:a1c:964f:: with SMTP id y76mr16913897wmd.62.1576855899425;
        Fri, 20 Dec 2019 07:31:39 -0800 (PST)
Received: from [192.168.8.147] (72.173.185.81.rev.sfr.net. [81.185.173.72])
        by smtp.gmail.com with ESMTPSA id l2sm9795192wmi.5.2019.12.20.07.31.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 07:31:38 -0800 (PST)
Subject: Re: [PATCH net-next v5 08/11] tcp: Export TCP functions and ops
 struct
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
 <20191219223434.19722-9-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <35243533-62c3-761b-f067-10ff5b3b27cc@gmail.com>
Date:   Fri, 20 Dec 2019 07:31:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219223434.19722-9-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/19 2:34 PM, Mat Martineau wrote:
> MPTCP will make use of tcp_send_mss() and tcp_push() when sending
> data to specific TCP subflows.
> 
> tcp_request_sock_ipvX_ops and ipvX_specific will be referenced
> during TCP subflow creation.
> 
> Co-developed-by: Peter Krystad <peter.krystad@linux.intel.com>
> Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

