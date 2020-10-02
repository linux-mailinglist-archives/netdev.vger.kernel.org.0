Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABA6281D11
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgJBUnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:43:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41172 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgJBUnb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 16:43:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kORtl-00HK49-7P; Fri, 02 Oct 2020 22:43:25 +0200
Date:   Fri, 2 Oct 2020 22:43:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 5/6] bonding: update Documentation for
 port/bond terminology
Message-ID: <20201002204325.GJ3996795@lunn.ch>
References: <20201002174001.3012643-1-jarod@redhat.com>
 <20201002174001.3012643-6-jarod@redhat.com>
 <20201002180906.GG3996795@lunn.ch>
 <CAKfmpSd00=ryeznA3ubfMCmeiFAeo-jQhvT3fAgwJqbDEL7w_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfmpSd00=ryeznA3ubfMCmeiFAeo-jQhvT3fAgwJqbDEL7w_w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 04:17:34PM -0400, Jarod Wilson wrote:
> On Fri, Oct 2, 2020 at 2:09 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Fri, Oct 02, 2020 at 01:40:00PM -0400, Jarod Wilson wrote:
> > > Point users to the new interface names instead of the old ones, where
> > > appropriate. Userspace bits referenced still include use of master/slave,
> > > but those can't be altered until userspace changes too, ideally after
> > > these changes propagate to the community at large.
> > >
> > > Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> > > Cc: Veaceslav Falico <vfalico@gmail.com>
> > > Cc: Andy Gospodarek <andy@greyhouse.net>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Thomas Davis <tadavis@lbl.gov>
> > > Cc: netdev@vger.kernel.org
> > > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > > ---
> > >  Documentation/networking/bonding.rst | 440 +++++++++++++--------------
> > >  1 file changed, 220 insertions(+), 220 deletions(-)
> > >
> > > diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> > > index adc314639085..f4c4f0fae83b 100644
> > > --- a/Documentation/networking/bonding.rst
> > > +++ b/Documentation/networking/bonding.rst
> > > @@ -167,22 +167,22 @@ or, for backwards compatibility, the option value.  E.g.,
> > >
> > >  The parameters are as follows:
> > >
> > > -active_slave
> > > +active_port
> >
> > Hi Jarod
> >
> > It is going to take quite a while before all distributions user space
> > gets updated. So todays API is going to live on for a few
> > years. People are going to be search the documentation using the terms
> > their user space uses, which are going to be todays terms, not the new
> > ones you are introducing here. For that to work, i think you are going
> > to have to introduce a table listing todays names and the new names
> > you are adding, so search engines have some chance of finding this
> > document, and readers have some clue as to how to translate from what
> > their user space is using to the terms used in the document.
> 
> Hm. Would a simple blurb describing the when the changes were made and
> why at the top of bonding.rst be sufficient? And then would the rest
> of the doc remain as-is (old master/slave language), or with
> terminology conversions?

I'm assuming you want to deprecate the old language? So i was
expecting the language to change. I would expect some explanation of
why the names have changed, and a table listing the old and new name.
We cannot completely get away from the old names, because they are
ABI, so we need to keep documenting them somehow.

	Andrew
