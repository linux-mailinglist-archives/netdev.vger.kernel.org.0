Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAE12A8D68
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 04:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgKFDNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 22:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKFDNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 22:13:40 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D51CC0613CF;
        Thu,  5 Nov 2020 19:13:40 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id x13so2853840pgp.7;
        Thu, 05 Nov 2020 19:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O3FOAmOzq4mRRFr0UiBrSyDYs50QdScSaBtAQ6V4i+g=;
        b=f9siciO5CJVP4uV4kJ02I+Kvl5dxV8jeyt2KX0udIBmLSNEHkRfIO+fT+QcJj0sVI+
         9PABIhU+KAT07wySaHQZpbOn0VuItbo1/Ty0Spi5gAjIeG8LSso3EH47RbpT6BHko4Bb
         H6ay617YurT5wYI5ZrTV6yofSul8VdBfX6saXry8GcwKCHbdMWct9jgQCe9ebGDODvS4
         88cheWSARrnwIMAKB6U8teEzNSq3sohV5GOXW4sStQMp6X6F16sGgEraWePkZzrc/HSQ
         YTeGyg7J2oU9k+89S+8oiDsMK93r6QLF/9b/tDgO8JUJeRkWisURKgt8PHdt/uc5WAc0
         b9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O3FOAmOzq4mRRFr0UiBrSyDYs50QdScSaBtAQ6V4i+g=;
        b=VZrzldvcEbFf1ntce9YDxoAE6rFOQTvib6bXEVglGBqGG5KARWsUioT6B2LNkfp59q
         5yyPsDj/3DxRa+V0KaQth4MYzAoOTe17yyciHHvmbTRORjH+oCbNIPoUKlQyWMyT+1aZ
         MARARfEITyWY4+CjSQc2UuAHNN31JLQaClXHPIX88Feah9uvzO2nbCcPO7NatSBu3Rk0
         +veBe4BcmFZMY+PViKhV15NfYseLak3l0/+HTGleBejBgtzJYT00dC94nYxv51prEWXS
         cta+9GCAXeB7G5CE6csoXeSjbg6lfH14VRDJvW5r6sR7EPG9NealbPxX18HAUnhwIbhn
         wV5Q==
X-Gm-Message-State: AOAM530ZEC13x6syhTH1hpBGxDt+zhus1HvGEXwR8u+j9SQsXf236CK2
        6Asum+QIK5UVGXFHAejwGBk=
X-Google-Smtp-Source: ABdhPJy6a3E/z70OOq/umZSl2dLAWg7M+/fgxUEPPz761yzyLJqfIVnvnzq6TE/dF99m1YOwGSU7uw==
X-Received: by 2002:a17:90b:3d5:: with SMTP id go21mr123838pjb.8.1604632420181;
        Thu, 05 Nov 2020 19:13:40 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:b55b])
        by smtp.gmail.com with ESMTPSA id k12sm60665pjf.22.2020.11.05.19.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 19:13:39 -0800 (PST)
Date:   Thu, 5 Nov 2020 19:13:36 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [RFC PATCH bpf-next 3/5] kbuild: Add
 CONFIG_DEBUG_INFO_BTF_MODULES option or module BTFs
Message-ID: <20201106031336.b2cufwpncvft2hs7@ast-mbp>
References: <20201105045140.2589346-1-andrii@kernel.org>
 <20201105045140.2589346-4-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105045140.2589346-4-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 08:51:38PM -0800, Andrii Nakryiko wrote:
>  
> +config DEBUG_INFO_BTF_MODULES
> +	bool "Generate BTF for kernel modules"
> +	def_bool y
> +	depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF

Does it need to be a new config ?
Can the build ran pahole if DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF ?
