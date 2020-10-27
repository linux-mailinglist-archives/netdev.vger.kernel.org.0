Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA75D29A57E
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 08:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507631AbgJ0H0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 03:26:34 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59650 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732574AbgJ0H0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 03:26:33 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kXJNC-00DPj2-Mi; Tue, 27 Oct 2020 08:26:26 +0100
Message-ID: <bee691201828c96cb5ac678d8ab65e8ecd934364.camel@sipsolutions.net>
Subject: Re: [PATCH v3 21/56] mac80211: fix kernel-doc markups
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 27 Oct 2020 08:26:20 +0100
In-Reply-To: <978d35eef2dc76e21c81931804e4eaefbd6d635e.1603469755.git.mchehab+huawei@kernel.org>
References: <cover.1603469755.git.mchehab+huawei@kernel.org>
         <978d35eef2dc76e21c81931804e4eaefbd6d635e.1603469755.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-23 at 18:33 +0200, Mauro Carvalho Chehab wrote:
> Some identifiers have different names between their prototypes
> and the kernel-doc markup.
> 
> Others need to be fixed, as kernel-doc markups should use this format:
>         identifier - description
> 
> In the specific case of __sta_info_flush(), add a documentation
> for sta_info_flush(), as this one is the one used outside
> sta_info.c.

Are you taking the entire series through some tree, or should I pick up
this patch?

If you're going to take it:

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes


