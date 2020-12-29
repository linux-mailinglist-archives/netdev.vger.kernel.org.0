Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1F72E6EFF
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 09:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgL2IhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 03:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgL2IhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 03:37:07 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216AAC061793;
        Tue, 29 Dec 2020 00:36:27 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id m12so29228642lfo.7;
        Tue, 29 Dec 2020 00:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/rmiM7MYrMcNAwLIDIn8mjB1jSx3iRPbbD5GnB3O6jQ=;
        b=JfkeTGYijSD7wJXsTKZHD1NrqetEqdXi3Yv3vzUaESFYp3laxoHS31BcMVLn8vdqC7
         fwHXYDGfVjNtFTq9nt9hs9RhtxA3qh1MyTdH6eNZnvh8RmhuRKE+t8f9gxPmQFXTWsIv
         b0qbpkAHoM3nuE8zfO9txizUr6GZ/57rXlCpCasaMWY57iTPQsRGoEw0VRaOvo0Gj6sL
         oJsqKufqZtJoAoEn83xzzLUb1nNKMsuWRyMNIFXhHc+2JAOVs7DSrGYUGruqTKHr+B1p
         Mo0EQTEN5PD/ZV6eYXi+ajac11hQ0M81Ee/9zsxFROtTXroIJLl2RPFIqOXHhM8urjBr
         RbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/rmiM7MYrMcNAwLIDIn8mjB1jSx3iRPbbD5GnB3O6jQ=;
        b=Etz/kWbbgdHJ+z3eT6MMSUFcaefxiDOX5KIkxAN6riqn88lWBnOMT24XEb1EMWclLZ
         BhoSFe1YtDvwht+FabO2ebj8Ov07x5ycMeihm+lTetZXC9rsy86eyuZSWYQO4lwjLQof
         +pSMvsgljRydcwX9Bd1WlQd1HW6V7VoVw5QQ5fX+XpvMGnyqC11U5+FtaQYL3tUMlxGn
         LSAjqTdVUakPIuaaApJ9CfCVMTG3O/fBZQHVQuA1zJhXIIJiI29Dbj/i2blACBu9/FVi
         mDcPdYlwjd2w4zJBhAH9chmIJ84vK/h5KmM8O4Z9nHArS+s27ed0MeSNOYtO3UC6OYaT
         i5jw==
X-Gm-Message-State: AOAM532nkvHgBJ2XCcEBBrZNosdBX/wFgdMoMuRY8p7IB4QZCG58Ucyk
        VzWeIDg/N4un5pQ0lTGlnwQVHc44usE=
X-Google-Smtp-Source: ABdhPJzN0soALZsRsiKsJwr3KCiTu/b4elClyWK87yklLk4lJwt8eY7K0SK4oZvLw0/8vdlOe0AvXw==
X-Received: by 2002:ac2:46cd:: with SMTP id p13mr21672374lfo.86.1609230983702;
        Tue, 29 Dec 2020 00:36:23 -0800 (PST)
Received: from [192.168.1.100] ([178.176.78.246])
        by smtp.gmail.com with ESMTPSA id a22sm6565446ljq.109.2020.12.29.00.36.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Dec 2020 00:36:23 -0800 (PST)
Subject: Re: [PATCH 2/4] ARM: dts: renesas: Add fck to etheravb-rcar-gen2
 clock-names list
To:     Adam Ford <aford173@gmail.com>, linux-renesas-soc@vger.kernel.org
Cc:     aford@beaconembedded.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201228213121.2331449-1-aford173@gmail.com>
 <20201228213121.2331449-2-aford173@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <f86ae91b-badc-5042-066b-fbfe14925cd0@gmail.com>
Date:   Tue, 29 Dec 2020 11:36:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201228213121.2331449-2-aford173@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.12.2020 0:31, Adam Ford wrote:

> The bindings have been updated to support two clocks, but the
> original clock now requires the name fck.  Add a clock-names
> list in the device tree with fck in it.

    Hopefully this won't break RPM...

> Signed-off-by: Adam Ford <aford173@gmail.com>
[...]

MBR, Sergei
