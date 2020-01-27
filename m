Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC0314A5F5
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgA0OZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:25:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbgA0OZT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 09:25:19 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2369720716;
        Mon, 27 Jan 2020 14:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580135119;
        bh=bg56Ldz/RBxKM4HJmiXF4nnJGZhFUWOIGlGJ+sIOhTo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A2kJerg4OoCBbsVOMXqslzQIXwSDkXhrDT2U2sZOLO/h06EDNNGezZgJb2LJT9aeG
         DAG6FyRi7dEaJ5tXECbJ6/eu7AibHv3Gp4f6q8yRkLtNAAnY1qxShdfY784XcEND9C
         C8fZEiyniXXMtAzptDXSXNFu4qMWnI6vaICgrCqw=
Date:   Mon, 27 Jan 2020 06:25:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 14/16] devlink: add macros for "fw.roce" and
 "board.nvm_cfg"
Message-ID: <20200127062518.4274b802@cakuba>
In-Reply-To: <CAACQVJrc66xBDQRi0a_tShW6Ngtqtxwn5FUM_T8krt0cNe9d-w@mail.gmail.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
        <1580029390-32760-15-git-send-email-michael.chan@broadcom.com>
        <20200126161826.0e4df544@cakuba>
        <CAACQVJrc66xBDQRi0a_tShW6Ngtqtxwn5FUM_T8krt0cNe9d-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jan 2020 11:12:52 +0530, Vasundhara Volam wrote:
> On Mon, Jan 27, 2020 at 5:48 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Sun, 26 Jan 2020 04:03:08 -0500, Michael Chan wrote:  
> > > --- a/Documentation/networking/devlink/devlink-info.rst
> > > +++ b/Documentation/networking/devlink/devlink-info.rst
> > > @@ -59,6 +59,11 @@ board.manufacture
> > >
> > >  An identifier of the company or the facility which produced the part.
> > >
> > > +board.nvm_cfg
> > > +-------------
> > > +
> > > +Non-volatile memory version of the board.  
> >
> > Could you describe a little more detail? Sounds a little similar to
> > fw.psid which Mellanox has added, perhaps it serves the same purpose
> > and we could reuse that one?  
> It is almost similar. We can reuse and update documentation in
> bnxt.rst mentioning
> that parameter set is present in NVM .

Thanks!
