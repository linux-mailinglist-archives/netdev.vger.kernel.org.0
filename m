Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D07C9F1176
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 09:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfKFIw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 03:52:27 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35844 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfKFIw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 03:52:27 -0500
Received: by mail-wm1-f66.google.com with SMTP id c22so2357801wmd.1
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 00:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FM1ham6sNCijDqSM0YgumVSl/vnx1F+nm1sCDObiQGc=;
        b=RNgvjVDpQSmNxhkaabUNVmDGmmWBf83zO6dzQoCPVWEXtLI3VHCfSj2X8wbnsUKM6j
         0v6731oBeZFIHz4EJfToQXirpSqL3VRl9LlMab56/D/p0PPjgFQRMqu1v1TZ619rvyOW
         nph2r5tO+WSJtrB2gJeLJsBnlBWZJNRSwzXkHXRJJSHeDczS/QyTuC0s5+ZaQBJKn0IE
         2B/5bWIbr5JYLIJRhi0fRhNtwbdfDNxaB/xC0IY8HQM8ii/eexdIoMiBMkIr++/UH2Jt
         fdERU8eadw1RnATTKKmVQ4BYLDlEDfP/bWcHGsjksAktFnLxFKdNWMkDq63FZqVRMY3q
         iqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FM1ham6sNCijDqSM0YgumVSl/vnx1F+nm1sCDObiQGc=;
        b=RWpgYxQHEc7huhdIy00ZP4BPR5NqddqFovoLzVi/+MHJFWxcqVnqKp/3taMm6JsUxp
         wd86KRQv19hsoaEtSq5tTnEoLRGbf6EkqSeFNwvqe1J6yoXC+pvXGsmLDblyzVLvwoYi
         TTm1CSknxhC6iFV0hhNNVyY2xA98+pQqniQeDttLvtZMo5agy/1N/ywm04Ja028RCS5D
         CnGiTJ3Ezwv9jqYE6vz1i98W6EZ1f5z35PYNgKAa6KKGv4ZSwWzaG4To38HWmyUVz75O
         YzYgr2wfI+HCb0Dj55tTZ9nJIqEH305kDzzrdqsQIvQR8lm0tE+HT2/2F7r0NJGMm2QC
         jx9g==
X-Gm-Message-State: APjAAAXhr60oc6IMay3DdGa16m4QLqa1oxMkD57IPDtYRycPonqIYgsn
        kSqVknKOTbFMWpCl8LTg2NsLqA==
X-Google-Smtp-Source: APXvYqydWQj1vHkZRb9mR2C0nsaDUUgCdwT5JbMhLuQoVEIgCLLwvbjbKn0PLeO20hQ5Hgg8/Ja2rg==
X-Received: by 2002:a1c:740a:: with SMTP id p10mr1345856wmc.121.1573030343540;
        Wed, 06 Nov 2019 00:52:23 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id m13sm2089986wmc.41.2019.11.06.00.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 00:52:23 -0800 (PST)
Date:   Wed, 6 Nov 2019 09:52:22 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH iproute2-next 2/3] devlink: catch missing strings in
 dl_args_required
Message-ID: <20191106085222.GD2112@nanopsycho>
References: <20191105211707.10300-1-jakub.kicinski@netronome.com>
 <20191105211707.10300-3-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105211707.10300-3-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 05, 2019 at 10:17:06PM CET, jakub.kicinski@netronome.com wrote:
>Currently if dl_args_required doesn't contain a string
>for a given option the fact that the option is missing
>is silently ignored.
>
>Add a catch-all case and print a generic error.
>
>Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
