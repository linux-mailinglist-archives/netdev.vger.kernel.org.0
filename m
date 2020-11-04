Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4362A62CF
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 12:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgKDLBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 06:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgKDLBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 06:01:02 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D4AC0613D3;
        Wed,  4 Nov 2020 03:01:02 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id p5so29158500ejj.2;
        Wed, 04 Nov 2020 03:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rvW5R5Q9WCVeBYuGDUheJFXlqOni1qKu6KrAuvEkvl8=;
        b=RbgSE3pzlJAW6kIjXRJZc55zPDQJBI3iTtOoier5QYtFJaz3r1jMBbCjALNFBW3Bev
         DemysILNab+B/2aJ1MqKlzucdy5tO5ZJukZcuXJsDt2y902JEs8kvDFnGRBMlYHfKMSI
         TIOXu/6+iJf00Au/3UJGaVumpoUTKU4ypajwEYQJY/FndfDaON+RIbCb0fgilmr7641I
         wahPo7CPm1a9L4od8GvZVhTBXcfPhcd5vGWidCdApgjW64glRZJthMuxckdq/k9UG3ss
         NZ9ut04nfL1BxpeFC6Rx8aNa8cXrxOaQRWE17Nn849+0d7nLUCsWu0CTGq+eApN2eAtV
         q5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rvW5R5Q9WCVeBYuGDUheJFXlqOni1qKu6KrAuvEkvl8=;
        b=Qogngpnc0U37f+9MECe6sX33NeZEaXV2XO/yBR6kxWTyviyuuJKzkV/COC8mjdzRtW
         Cmz0HvDyhfZKoFhXDuHjqmYkL9ueTLHOi1V58YUN0i4FLEvvZFNn3iD9YDi4z8qQCxSP
         ZfYIFa9QW5D6OxqxakfeheEJ0sILsNRuM2x/OSQX2H5tPpmDg8mXSqRWwXMQrXnH3pnK
         nXwe44XRKSoL1rhM+zUqn4+Q1iQnpf0Ps+Vdjo3qbMlKnSFs68sw6ZBdtQf3HagieW80
         Aq/+GVzruDWCSmbXbRkIYTj9Xl8oqRoyGRzT0nLWnetIuR0UzZj1Ed/cRWBD6kg8mUJM
         AvAg==
X-Gm-Message-State: AOAM531rU9J/u0PQbETUYifIYnFuVEDLAQeHhC8W/vC4Kb6iUcVIUnBN
        h4e41BS5loVeXEYTG6HSN0A=
X-Google-Smtp-Source: ABdhPJxf7E0NueX4eI3gZDtOrNDXnVtbsPQoKEWY55zVSv2iOZKFixhlFfepSF85mk6T02K6OsqONw==
X-Received: by 2002:a17:906:d0cd:: with SMTP id bq13mr4480735ejb.372.1604487661145;
        Wed, 04 Nov 2020 03:01:01 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id j1sm792350ejd.47.2020.11.04.03.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 03:01:00 -0800 (PST)
Date:   Wed, 4 Nov 2020 13:00:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Message-ID: <20201104110059.whkku3zlck6spnzj@skbuf>
References: <20201103192226.2455-1-kabel@kernel.org>
 <20201103192226.2455-4-kabel@kernel.org>
 <20201103214712.dzwpkj6d5val6536@skbuf>
 <20201104065524.36a85743@kernel.org>
 <20201104084710.wr3eq4orjspwqvss@skbuf>
 <20201104112511.78643f6e@kernel.org>
 <20201104113545.0428f3fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104113545.0428f3fe@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 11:35:45AM +0100, Marek Behún wrote:
> Or something like this?
> 
> #define DEF_R_FUNC(_t, _r, _r_i, _mcu)				\
> static inline _t _r(struct r8152 *tp, u16 index)		\
> {								\
> 	return _r_i(tp, _mcu, index);				\
> }
> 
> #define DEF_W_FUNC(_t, _w, _w_i, _mcu)				\
> static inline void _w(struct r8152 *tp, u16 index, _t data)	\
> {								\
> 	_w_i(tp, _mcu, index, data);				\
> }
> 
> DEF_R_FUNC(u8, pla_ocp_read_byte, ocp_read_byte, MCU_TYPE_PLA)
> DEF_W_FUNC(u8, pla_ocp_write_byte, ocp_write_byte, MCU_TYPE_PLA)
> DEF_R_FUNC(u16, pla_ocp_read_word, ocp_read_word, MCU_TYPE_PLA)
> DEF_W_FUNC(u16, pla_ocp_write_word, ocp_write_word, MCU_TYPE_PLA)
> DEF_R_FUNC(u32, pla_ocp_read_dword, ocp_read_dword, MCU_TYPE_PLA)
> DEF_W_FUNC(u32, pla_ocp_write_dword, ocp_write_dword, MCU_TYPE_PLA)
> 
> DEF_R_FUNC(u8, usb_ocp_read_byte, ocp_read_byte, MCU_TYPE_USB)
> DEF_W_FUNC(u8, usb_ocp_write_byte, ocp_write_byte, MCU_TYPE_USB)
> DEF_R_FUNC(u16, usb_ocp_read_word, ocp_read_word, MCU_TYPE_USB)
> DEF_W_FUNC(u16, usb_ocp_write_word, ocp_write_word, MCU_TYPE_USB)
> DEF_R_FUNC(u32, usb_ocp_read_dword, ocp_read_dword, MCU_TYPE_USB)
> DEF_W_FUNC(u32, usb_ocp_write_dword, ocp_write_dword, MCU_TYPE_USB)

I'm not sure it's worth the change :(
Let's put it another way, your diffstat has 338 insertions and 335
deletions. Aka you're saving 3 lines overall.
With this new approach that doesn't use token concatenation at all,
you're probably not saving anything at all.
Also, I'm not sure that you need to make the functions inline. The
compiler should be smart enough to not generate functions for
usb_ocp_read_byte etc. You can check with
"make drivers/net/usb/r8152.lst".
