Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AA91A8803
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 19:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503081AbgDNRyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 13:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729303AbgDNRyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 13:54:47 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 599802074D;
        Tue, 14 Apr 2020 17:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586886887;
        bh=IA9FHJ0vJjpnKmumofUoH+p/hbU24ui/rtshYOP3khQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z8GAWBOFXAPJ1BbmzPFQNTZo90hCmMBAfe+fsMRxW1zyzwqO4Cy7rJs9TCpmJhrZU
         eCwDH/wzTPIjWtEp2cWykbTNFy2ynlKoeslE6BSW0H2nmPFx8jRZ73/OW/DRz2wX0U
         rgi9OTwMtuwnsn7qoBwnJytQeZ0XJqBHOVrrKph4=
Date:   Tue, 14 Apr 2020 20:54:35 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Borislav Petkov <bp@suse.de>
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
Message-ID: <20200414175435.GF1011271@unreal>
References: <20200414155732.1236944-1-leon@kernel.org>
 <20200414155732.1236944-2-leon@kernel.org>
 <20200414160041.GG31763@zn.tnic>
 <20200414172604.GD1011271@unreal>
 <20200414174432.GI31763@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200414174432.GI31763@zn.tnic>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 07:44:32PM +0200, Borislav Petkov wrote:
> On Tue, Apr 14, 2020 at 08:26:04PM +0300, Leon Romanovsky wrote:
> > I personally don't use such notation and rely on the submission flow.
> >
> > The patch has two authors both written in SOBs and it will be visible
> > in the git history that those SOBs are not maintainers additions.
>
> A lonely SOB doesn't explain what the involvement of the person is. It
> is even documented:
>
> Documentation/process/submitting-patches.rst
>
> Section 12) When to use Acked-by:, Cc:, and Co-developed-by:

I know, and never liked that "Co-developed-by" tag and prefer
to be in old school camp who uses SOB to mark the author. :)

>
> I guess that is the maintainer of the respective tree's call in the end.
>
> > Can you please reply to the original patch with extra tags you want,
> > so b4 and patchworks will pick them without me resending the patches?
>
> Ok.

Thanks

>
> --
> Regards/Gruss,
>     Boris.
>
> SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
