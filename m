Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085DA1A87D8
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 19:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502277AbgDNRou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 13:44:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:52116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502278AbgDNRoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 13:44:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0A901AEED;
        Tue, 14 Apr 2020 17:44:41 +0000 (UTC)
Date:   Tue, 14 Apr 2020 19:44:32 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ion Badulescu <ionut@badula.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org, Pensando Drivers <drivers@pensando.io>,
        Sebastian Reichel <sre@kernel.org>,
        Shannon Nelson <snelson@pensando.io>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: Re: [PATCH net-next 1/4] drivers: Remove inclusion of vermagic header
Message-ID: <20200414174432.GI31763@zn.tnic>
References: <20200414155732.1236944-1-leon@kernel.org>
 <20200414155732.1236944-2-leon@kernel.org>
 <20200414160041.GG31763@zn.tnic>
 <20200414172604.GD1011271@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200414172604.GD1011271@unreal>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 08:26:04PM +0300, Leon Romanovsky wrote:
> I personally don't use such notation and rely on the submission flow.
>
> The patch has two authors both written in SOBs and it will be visible
> in the git history that those SOBs are not maintainers additions.

A lonely SOB doesn't explain what the involvement of the person is. It
is even documented:

Documentation/process/submitting-patches.rst

Section 12) When to use Acked-by:, Cc:, and Co-developed-by:

I guess that is the maintainer of the respective tree's call in the end.

> Can you please reply to the original patch with extra tags you want,
> so b4 and patchworks will pick them without me resending the patches?

Ok.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
