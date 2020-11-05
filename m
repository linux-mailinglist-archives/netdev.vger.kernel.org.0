Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005642A7C6E
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 11:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730153AbgKEK4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 05:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730069AbgKEK4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 05:56:45 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11400C0613CF;
        Thu,  5 Nov 2020 02:56:45 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id oq3so1952915ejb.7;
        Thu, 05 Nov 2020 02:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=AtroSstUCyILeySaqdfODVVqHZHsfk6Z9ZPz46kg3Uk=;
        b=uJPNm/9fX3Jf24EnO4xc7KbgtzTtSXE6BXX3IWTEed2qtNk5ipkQ8Z1P4a18M0vaBB
         PyPSp9f5xIKMG4K02fxqMVRu2zqMNp5qbhUfs/28Tc7aFjxvSTYichUvs6rv+QMNLQvs
         qit6fCGQagC0F0r6CWh3Z2MSoR1R01+beNFFYeTCZu5L0DamVlns97F8BtnfmJKURrgK
         InncOII52BV2qICMswBBCDj4lsvtQDa7ARU8kCWybA3RDTUEzah4vqpXXHODsUUD4iYF
         rxyeHksLagvVpemCUD5lI1xrMJDeh9vKmatgb/eBfhiBfr/wOjwahXKSe+mWoH/EAxx8
         8Hzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=AtroSstUCyILeySaqdfODVVqHZHsfk6Z9ZPz46kg3Uk=;
        b=M/utkE/CR4zCfdCTFzarRf3/D0JNRAIgtLiDXv74ch7NHelaAIE53HMhTIJ0JvBhK2
         yKA+0WN+ifbW4Yb5N2SbC78a3saEJ3lmn6bg+GgqHEBfqxs/8qF31egaupgyed7LN1W1
         u3PvkaffGkJF9qLnNXEOA3Vh1X/QzTNIKWxXYWN8edCTnHeXjMUJP2F9XGyUS7MomKUH
         6RFdSPv0s4VsL4mDHnLiuIW63yBHxj91k5OTuRkaqb+U9/Y+A6Q33ekwe8Uyp93wMP82
         2GMAmLDO9NUcCnxMqFYz6zs5pTLy4z/j3qtO4yr0dGbnliHdLKvrmnagdHB6I9wcIna8
         oSyw==
X-Gm-Message-State: AOAM533PlAtUK/BTlN7S3A19bnmwDJJlXWqasNwS4Xvop40T51mqFb9s
        v2nQh2vp9kkLMh9NW4QD6Ck=
X-Google-Smtp-Source: ABdhPJwImWuTsjbha72MzYhweiG73gxU/PCNOwPm29v3UZUaq05ZSrQ8wDTOcFlhqh+3kxKUrdtKJA==
X-Received: by 2002:a17:906:a14c:: with SMTP id bu12mr1732678ejb.444.1604573803817;
        Thu, 05 Nov 2020 02:56:43 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id o31sm656257edd.94.2020.11.05.02.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 02:56:43 -0800 (PST)
Date:   Thu, 5 Nov 2020 12:56:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Message-ID: <20201105105642.pgdxxlytpindj5fq@skbuf>
References: <20201103192226.2455-4-kabel@kernel.org>
 <20201103214712.dzwpkj6d5val6536@skbuf>
 <20201104065524.36a85743@kernel.org>
 <20201104084710.wr3eq4orjspwqvss@skbuf>
 <20201104112511.78643f6e@kernel.org>
 <20201104113545.0428f3fe@kernel.org>
 <20201104110059.whkku3zlck6spnzj@skbuf>
 <20201104121053.44fae8c7@kernel.org>
 <20201104121424.th4v6b3ucjhro5d3@skbuf>
 <20201105105418.555d6e54@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201105105418.555d6e54@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 10:54:18AM +0100, Marek Behún wrote:
> I thought that static inline functions are preferred to macros, since
> compiler warns better if they are used incorrectly...

Citation needed. Also, how do static inline functions wrapped in macros
(i.e. your patch) stack up against your claim about better warnings?
I guess ease of maintainership should prevail here, and Hayes should
have the final word. I don't really have any stake here.
