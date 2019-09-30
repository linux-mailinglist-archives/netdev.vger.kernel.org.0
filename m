Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32794C2553
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732329AbfI3Qmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:42:39 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44261 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbfI3Qmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 12:42:39 -0400
Received: by mail-pg1-f193.google.com with SMTP id i14so7666658pgt.11
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 09:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LHA5rNfKoUV9YgSSU2Br00QqbsLipsUqyC9jTJ2RhQA=;
        b=hIKjdCnMQaduQtnLkPirYRJQmHjN7CTzXGYkmtXlWzVPxeWm91ifkTHM3d2oilUZdA
         0iOYmSQ9V1eB0x6SeH4/EBtKqK8yFUs9ktl2a1u8JPxu42KuQX72KD7NCrYzfRbeX8l5
         BOQ0rsYrV85gPDmlOfRKDT/7rfWR5+aZo63/gDPG1yXLbvXyWPdTyL2g78BEgtjqXTDy
         uGBKbuhsKz0DVyee8x1yyxrQ04KIkls8ZCb2TLa8DirYRZ23xHlEqBRdFlhjgNnqKtNv
         XcZwtYDsn7P707EeWvGTp9LY1Ct5nhjg8vDxshUhl4GXRg0Q3GdMB9Ak4TrFIjAd8Ab0
         e92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LHA5rNfKoUV9YgSSU2Br00QqbsLipsUqyC9jTJ2RhQA=;
        b=hAMcGMSfQQ8KW28Ny029svncTTElRypJ7F/GJgvEuZ4Zoqv55Dace4MDRYPb2/wNMD
         AnQ6eNxBxnYlS9XvxM4Qui8AMmpGCbhswx11kAjueQkKk+pZ5Jq9CUhFlJ3sKNuAiUmF
         twJuPIPmMaet4B/Qm9CSYFsvWWBrJqL6pv5ww2RYyy8WZpzKZgVdOP+hBFQLfEBgD04D
         dZEJ22xEu4KwaQ0sJos2atPhNw+7PeKGpU1URWzYARTbd81Ig31yUSx//BL/nqHaJvvp
         /bdWTH+KMA9Yp9biiGvaiiefe7Yp0fxIN+01ulUVpOzHSbxf4HEfVklJiDx9tVYdikL0
         jPAw==
X-Gm-Message-State: APjAAAVkSDSeYg9LY5FSWj/z4TpV/dEG2ts4AtjPSNNU+B463uX596DV
        w6MBVXbXq0I31pButoxRl7M=
X-Google-Smtp-Source: APXvYqwdhonDPiXAm7UIh4svYEuGJs3NMj2Ke2OaDyFrVAcF7Z0G+qtk93jFmE9FKUnZnBbCtLVGsg==
X-Received: by 2002:a63:741c:: with SMTP id p28mr24932305pgc.147.1569861757600;
        Mon, 30 Sep 2019 09:42:37 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:38f1:aff0:4629:100f])
        by smtp.googlemail.com with ESMTPSA id c62sm13164626pfa.92.2019.09.30.09.42.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 09:42:36 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next v2 2/2] ipneigh: neigh get support
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        stephen@networkplumber.org
References: <1569702130-46433-1-git-send-email-roopa@cumulusnetworks.com>
 <1569702130-46433-3-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d256f178-ec5a-abaa-1528-0690d059b243@gmail.com>
Date:   Mon, 30 Sep 2019 10:42:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1569702130-46433-3-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/19 2:22 PM, Roopa Prabhu wrote:
> +
> +	req.ndm.ndm_family = dst.family;
> +	if (addattr_l(&req.n, sizeof(req), NDA_DST, &dst.data, dst.bytelen) < 0)
> +		return -1;
> +
> +	if (d) {
> +		ll_init_map(&rth);

ll_init_map is not needed and really not something you want to do (it
does a full link dump)

