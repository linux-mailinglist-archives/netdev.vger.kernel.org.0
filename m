Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 286AE1510FF
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 21:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBCU2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 15:28:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgBCU2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 15:28:05 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9AE22087E;
        Mon,  3 Feb 2020 20:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580761685;
        bh=3er9Mbo1MF0RwB7FU4DQbVlZanm0eWeQ0U0klGwIWRI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ViVA2f8T5fE2GoFExizvlmM/BqtEfVu0VCloXYg35GL8rNGObeRbFtWpkOlcn6lKt
         JZZUP8hXnkYQemqkkXQQ/kW3Fkh+XeNEOviy8zCMSq8IvN+07/x6b/UUYeCDQj5ZCO
         9knCSt+PBhZ3keibcg+3XJ9YB6jv/E6GX6qA1YI4=
Date:   Mon, 3 Feb 2020 12:28:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/4] rxrpc: Fixes ver #2
Message-ID: <20200203122804.2926cd6f@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1004693.1580758734@warthog.procyon.org.uk>
References: <20200203103914.4b038cb7@cakuba.hsd1.ca.comcast.net>
        <158072584492.743488.4616022353630142921.stgit@warthog.procyon.org.uk>
        <1004693.1580758734@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 03 Feb 2020 19:38:54 +0000, David Howells wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > Should I queue these for stable? There are some fixes to fixes here, 
> > so AFAIK we need:
> > 
> > 5273a191dca65a675dc0bcf3909e59c6933e2831   4.9+
> > 04d36d748fac349b068ef621611f454010054c58   4.19+
> > f71dbf2fb28489a79bde0dca1c8adfb9cdb20a6b   4.9+
> > fac20b9e738523fc884ee3ea5be360a321cd8bad   4.19+  
> 
> Yes, please.  DaveM asked me not to put stable tags in my net patches, IIRC,
> as his scripts do that automagically.

Yup, I'll queue these up.
