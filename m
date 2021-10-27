Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F273D43CD26
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbhJ0PN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:13:29 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:54107 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234640AbhJ0PNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 11:13:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9F55F58061E;
        Wed, 27 Oct 2021 11:10:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 27 Oct 2021 11:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=R6eD8s
        U+mUAvQsxnh8GBjddlGvAFTfv9v84Yk822mOM=; b=LV0fxoTbDMe8MHyGGnky6A
        Bgnk5gjxH5INNAiJpwXDmxyKz2Dqfi9xTgUDw/E36C8x1U9sVE7sLqhN06q5i4rp
        BUtIISgNzyN2qDBhlUrJ0TrPZhbPr+H/yZ+0mTXe2vULdzHm5jv3cWqqgYgpWA0v
        7m4X4PKEAZuVor8NxVdyU0lSH3jrjoFszz4MvWD3TTYeBH5V0JmmSXvBZLHKczNv
        qBL1okooWhZUbxjVukg6h3oIGWi81JmFL4LM0HAfUK723wN9Dhq84O/9BEBz+1uO
        jqjw35zKPgpDwFxDvsSn+UMQamm0WCjWOhhBdnGBaXFLwva9n1YchEiLzKxm3puw
        ==
X-ME-Sender: <xms:-Wt5Ydu8hVh1RAcM0iqi_mwBmq3mjxvLEtT2wuHtDkhXFNAf_LO2lg>
    <xme:-Wt5YWdHeCTR2y0M7ph280xqL4I7Asrg1G4fxRLyzIhezf-GbvUOqBywlKa3V-IZ_
    sRSJPLTIWRF9Mo>
X-ME-Received: <xmr:-Wt5YQxJsbPdsCVea1raNhxJNkjz87fbCDG0YFetkuYpLhMgckGRSt-r5g_EAvfsiiKCl_uKZ9Dns0m-_mX-qFMN453B6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:-Wt5YUNOEM7DEqdq0xlFDONCTTyEAH6RA8AMtoL1Rl99pcNyZ05vSw>
    <xmx:-Wt5Yd9ISd8RDZWJygGj-1qrmMCMlkj6mr-n5OFo7WpedbKTFfk-4A>
    <xmx:-Wt5YUX9JvocFF2Momh29CBeQVumFRHS5_2-Iuh7CCdoF9ZSs8ToSw>
    <xmx:-mt5YcaFMSamRMWoYBDY7qlzyic3L-YBarDYumGYiT8GEDUq_VwsfA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 11:10:48 -0400 (EDT)
Date:   Wed, 27 Oct 2021 18:10:46 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [RFC v5 net-next 2/5] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Message-ID: <YXlr9jEZ6jrywpe9@shredder>
References: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
 <20211026173146.1031412-3-maciej.machnikowski@intel.com>
 <YXj7WkEb0PagWfSw@shredder>
 <PH0PR11MB495191854BF5470E9BF223F5EA859@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB495191854BF5470E9BF223F5EA859@PH0PR11MB4951.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 01:16:22PM +0000, Machnikowski, Maciej wrote:
> 
> 
> > -----Original Message-----
> > From: Ido Schimmel <idosch@idosch.org>
> > Sent: Wednesday, October 27, 2021 9:10 AM
> > To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> > Subject: Re: [RFC v5 net-next 2/5] rtnetlink: Add new RTM_GETEECSTATE
> > message to get SyncE status
> > 
> > On Tue, Oct 26, 2021 at 07:31:43PM +0200, Maciej Machnikowski wrote:
> > > +/* SyncE section */
> > > +
> > > +enum if_eec_state {
> > > +	IF_EEC_STATE_INVALID = 0,
> > > +	IF_EEC_STATE_FREERUN,
> > > +	IF_EEC_STATE_LOCKED,
> > > +	IF_EEC_STATE_LOCKED_HO_ACQ,
> > 
> > Is this referring to "Locked mode, acquiring holdover: This is a
> > temporary mode, when coming from free-run, to acquire holdover
> > memory."
> > ?
> 
> Locked HO ACQ means locked and holdover acquired. It's the state that
> allows transferring to the holdover state. Locked means that we locked
> our frequency and started acquiring the holdover memory.

So that's a transient state, right? FWIW, I find it weird to call such a
state "LOCKED".

>  
> > It seems ice isn't using it, so maybe drop it? Can be added later in
> > case we have a driver that can report it
> 
> I'll update the driver in the next revision

You mean update it to use "IF_EEC_STATE_LOCKED_HO_ACQ" instead of
"IF_EEC_STATE_LOCKED"?

Regardless, would be good to document these values.

>  
> > There is also "Locked mode, holdover acquired: This is a steady state
> > mode, entered when holdover memory is acquired." But I assume that's
> > "IF_EEC_STATE_LOCKED"
> > 
> > > +	IF_EEC_STATE_HOLDOVER,
> > > +};
