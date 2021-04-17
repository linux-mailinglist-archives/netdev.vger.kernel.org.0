Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51E53631F5
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 21:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236782AbhDQTX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 15:23:29 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54751 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235234AbhDQTX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 15:23:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 31E175C0109;
        Sat, 17 Apr 2021 15:23:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 17 Apr 2021 15:23:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=OWcDEp
        M4F395+b8JT3MQmGj8xTliAeH7vGddShFUYdI=; b=F85FX8GOVz8j+/MgxDPPR2
        8Wz+RiUj9E2wptRdck/9nnzZB8f7V0EEHYj65dgHOa1nGKNGwfLITyez0NP9xWi9
        JBc6Ec64Mzg1EdI17dgFMXrza0yxzQhxbAVkTcF6puThdSnlHipgvMXSRCOsB8PC
        yDnwV4LXsgrmy7+N5jW4ZOvz+3cx3KQ3nsDk2baajJgxBTsnp0weu/BTdEpGmPvP
        kGsR7YpUp8ZOkyZ/Q+TmqN1wUsrpHsi1huX41SDKNr8IyWa0f9o4klrChunmQD+q
        CcsYqmkJUk7874WrrcrFCE4j1TRZgABz78ox4Ql1AjlEfHWSao8kW7sidMaxeong
        ==
X-ME-Sender: <xms:lTV7YHip18lPXJ41UiEIMvoqK4q66k6r6rKkomC6wBLEchzNJvAwLw>
    <xme:lTV7YEAUq0V8Ep4Vzn2OLkm73Y8CwICxcAPXrIx6bwUK7HhjOwFI-rKBEwWBPvqSm
    oCaaJuEbA1XDtE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeliedgvdeihecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhf
    etgfeuuefgvedtieehudeuueekhfduheelteenucfkphepkeegrddvvdelrdduheefrddu
    keejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:lTV7YHF3aYCRdCLlLK9tPDg3Wdyp8oICebEv0sJtlTQDpD8PiVrQ9A>
    <xmx:lTV7YETNRs1TaYfor9EsmmCXe21v5uVB265iktNCs6yL2xX-OyXSlQ>
    <xmx:lTV7YExChHLGt9BJkFFpuBfVOQpSCUogEVJ8qmqtNxnYsMAqQg_Eig>
    <xmx:ljV7YKaxaanZ-I22w6nyAQY9zPf0X26nOYhEBGSI53VvrAWMy5fkpw>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 263DA240054;
        Sat, 17 Apr 2021 15:23:00 -0400 (EDT)
Date:   Sat, 17 Apr 2021 22:22:57 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, idosch@nvidia.com, mkubecek@suse.cz
Subject: Re: [RFC ethtool 6/6] netlink: add support for standard stats
Message-ID: <YHs1kSQWxJf03uqV@shredder.lan>
References: <20210416160252.2830567-1-kuba@kernel.org>
 <20210416160252.2830567-7-kuba@kernel.org>
 <YHslkLKkb825OUEI@shredder.lan>
 <20210417114728.660490a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210417114728.660490a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 11:47:28AM -0700, Jakub Kicinski wrote:
> On Sat, 17 Apr 2021 21:14:40 +0300 Ido Schimmel wrote:
> > > +	if (!is_json_context()) {
> > > +		fprintf(stdout, "rmon-%s-etherStatsPkts",
> > > +			mnl_attr_get_type(hist) == ETHTOOL_A_STATS_GRP_HIST_RX ?
> > > +			"rx" : "tx");
> > > +
> > > +		if (low && hi) {
> > > +			fprintf(stdout, "%uto%uOctets: %llu\n", low, hi, val);
> > > +		} else if (hi) {
> > > +			fprintf(stdout, "%uOctets: %llu\n", hi, val);
> > > +		} else if (low) {
> > > +			fprintf(stdout, "%utoMaxOctets: %llu\n", low, val);
> > > +		} else {
> > > +			fprintf(stderr, "invalid kernel response - bad histogram entry bounds\n");
> > > +			return 1;
> > > +		}
> > > +	} else {
> > > +		open_json_object(NULL);
> > > +		print_uint(PRINT_JSON, "low", NULL, low);
> > > +		print_uint(PRINT_JSON, "high", NULL, hi);
> > > +		print_u64(PRINT_JSON, "val", NULL, val);  
> > 
> > In the non-JSON output you distinguish between Rx/Tx, but it's missing
> > from the JSON output as can be seen in your example:
> > 
> > ```
> >        "pktsNtoM": [
> >          {
> >            "low": 0,
> >            "high": 64,
> >            "val": 1
> >          },
> >          {
> >            "low": 128,
> >            "high": 255,
> >            "val": 1
> >          },
> >          {
> >            "low": 1024,
> >            "high": 0,
> >            "val": 0
> >          }
> >        ]
> > ```
> > 
> > I see that mlxsw and mlx5 only support Rx, but it's going to be
> > confusing with bnxt that supports both Rx and Tx.
> 
> Good catch! I added Tx last minute (even though it's non standard).
> I'll split split into two arrays - "rx-pktsNtoM" and "tx-pktsNtoM",
> sounds good? Or we can add a layer: ["pktsNtoM"]["rx"] etc.

I'm fine with both, but I think the first form will be easier when
working with jq to extract Rx/Tx. It is also more inline with the
current nesting of the netlink attributes.

> 
> > Made me think about the structure of these attributes. Currently you
> > have:
> > 
> > ETHTOOL_A_STATS_GRP_HIST_RX
> > 	ETHTOOL_A_STATS_GRP_HIST_BKT_LOW
> > 	ETHTOOL_A_STATS_GRP_HIST_BKT_HI
> > 	ETHTOOL_A_STATS_GRP_HIST_VAL
> > 
> > ETHTOOL_A_STATS_GRP_HIST_TX
> > 	ETHTOOL_A_STATS_GRP_HIST_BKT_LOW
> > 	ETHTOOL_A_STATS_GRP_HIST_BKT_HI
> > 	ETHTOOL_A_STATS_GRP_HIST_VAL
> > 
> > Did you consider:
> > 
> > ETHTOOL_A_STATS_GRP_HIST
> > 	ETHTOOL_A_STATS_GRP_HIST_BKT_LOW
> > 	ETHTOOL_A_STATS_GRP_HIST_BKT_HI
> > 	ETHTOOL_A_STATS_GRP_HIST_VAL
> > 	ETHTOOL_A_STATS_GRP_HIST_BKT_UNITS
> > 	ETHTOOL_A_STATS_GRP_HIST_TYPE
> 
> I went back and forth on that. The reason I put the direction in the
> type is that normal statistics don't have an extra _TYPE or direction.
> 
> It will also be easier to break the stats out to arrays if they are
> typed on the outside, see below.
> 
> > So you will have something like:
> > 
> > ETHTOOL_A_STATS_GRP_HIST_BKT_UNITS_BYTES
> 
> Histogram has two dimensions, what's the second dimension for bytes?
> Time? Packet arrival?

Not sure what you mean. Here you are counting how many Rx/Tx packets are
between N to M bytes in length. I meant to add two attributes. One that
tells user space that you are counting Rx/Tx packets and the second that
N to M are in bytes.

But given your comment below about this histogram probably being a one
time thing, I think maybe staying with the current attributes is OK.
There is no need to over-engineer it if we don't see ourselves adding
new histograms.

Anyway, these histograms are under ETHTOOL_A_STATS_GRP that should give
user space all the context about what is being counted.

> 
> > ETHTOOL_A_STATS_GRP_HIST_VAL_TYPE_RX_PACKETS
> > ETHTOOL_A_STATS_GRP_HIST_VAL_TYPE_TX_PACKETS
> > 
> > And it will allow you to get rid of the special casing of the RMON stuff
> > below:
> > 
> > ```
> > 	if (id == ETHTOOL_STATS_RMON) {
> > 		open_json_array("pktsNtoM", "");
> > 
> > 		mnl_attr_for_each_nested(attr, grp) {
> > 			s = mnl_attr_get_type(attr);
> > 			if (s != ETHTOOL_A_STATS_GRP_HIST_RX &&
> > 			    s != ETHTOOL_A_STATS_GRP_HIST_TX)
> > 				continue;
> > 
> > 			if (parse_rmon_hist(attr))
> > 				goto err_close_rmon;
> > 		}
> > 		close_json_array("");
> > 	}
> > ```
> 
> We can drop the if, but we still need a separate for() loop
> to be able to place those entries in a JSON array.
> 
> > I don't know how many histograms we are going to have as part of RFCs,
> > but at least mlxsw also supports histograms of the Tx queue depth and
> > latency. Not to be exposed by this interface, but shows the importance
> > of encoding the units.
> 
> TBH I hope we'll never use the hist for anything else. Sadly the
> bucketing of various drivers is really different (at least 6
> variants). But the overarching goal is a common interface for common
> port stats.
