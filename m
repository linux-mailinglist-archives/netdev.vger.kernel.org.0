Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B959652D2
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 10:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbfGKIHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 04:07:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37131 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbfGKIHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 04:07:31 -0400
Received: by mail-wm1-f68.google.com with SMTP id f17so4706615wme.2
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 01:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bN+BI6wIdU+MoWOdnpXpLGxCTIW1Fg0blX+8NzdMUmY=;
        b=frJoerEEtdkSn2e0SezwtrVPop8uFIljey35yuKI7YCdhlmsB4rmkfw4jTlGzoWV+K
         7pIPdTiueDXIYLIi4x0IIhQXJvdZngrpahtoq/BjvVuPdSX0devuVaVbAs/HeMfn5Bt9
         uYo1qgMA2EgpTOSpTzFix8P1AAFcILn7XeRGx8Pze6Inj/Wnbs8t57UlQQfobXZAsy3o
         VNi7ZKgKQ88yxCsTid3+trJJVilrKSjzoqKtPvUe3NhO8QTC61raUH+nyWOZ7p3PtxGE
         iO0VOrA+vdjpB7Ynaalbi3WRtqEIfX3hn5U47Kc1DGswEGAY2mbxogQT0xE4H3k0W8/j
         hm4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bN+BI6wIdU+MoWOdnpXpLGxCTIW1Fg0blX+8NzdMUmY=;
        b=VNoKResM9gZ1HWHG7lZb6VbThSpSBoEfHuGHE5aYoAjfwfm9g3dr1cbCMSlZJdQsyu
         RSaBh6rPQNewWaUQEanDIlsva8+5dy4o0kmXbfm5DtnME+oSWzYXEr3ZMbcL6D68QCoD
         cDurbuB2Rii6n/KlRtT/qAIQrn0FEpBTi4f1HB3bEkhwE4QB8Sv5iwuxZRSR6kDxtmB+
         3Mo1lfM3gCmDX9G+XUBao1bu4r4QLkDxrPD66lijiPxW0fzEqw4NxOxXbB8AYNrb5YIO
         vV6Up2hFJJT2fnU7MMDNhOfvPKy4f/OKrGQITGG2IsWfRC7mA8hjhghG/N2+ZqpfxhEE
         oQwQ==
X-Gm-Message-State: APjAAAXHwx/s76pABjzVsDLUSphmL4u5oNdYoshMfyfTby1qWVaqtHD5
        Mn1aUwvrcCdxOeLFJQkgJO8=
X-Google-Smtp-Source: APXvYqwFCk/2hg2gUoTbuWNo6ul2C70lsXx8D7T6+bRqvhQcCegN6k5QvNvs4bihylTJ9Yj6IBj6lw==
X-Received: by 2002:a7b:c38c:: with SMTP id s12mr2538541wmj.71.1562832449192;
        Thu, 11 Jul 2019 01:07:29 -0700 (PDT)
Received: from localhost (ip-89-176-1-116.net.upcbroadband.cz. [89.176.1.116])
        by smtp.gmail.com with ESMTPSA id c78sm5041017wmd.16.2019.07.11.01.07.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 01:07:28 -0700 (PDT)
Date:   Thu, 11 Jul 2019 10:07:28 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 2/3] net: flow_offload: rename tc_setup_cb_t to
 flow_setup_cb_t
Message-ID: <20190711080728.GG2291@nanopsycho>
References: <20190711001235.20686-1-pablo@netfilter.org>
 <20190711001235.20686-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711001235.20686-2-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 11, 2019 at 02:12:34AM CEST, pablo@netfilter.org wrote:
>Rename this type definition and adapt users.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Jiri Pirko <jiri@mellanox.com>
