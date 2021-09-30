Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8D941E2C2
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 22:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348271AbhI3Umu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 16:42:50 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36619 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229958AbhI3Umu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 16:42:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id BA47C5C00D8;
        Thu, 30 Sep 2021 16:41:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 30 Sep 2021 16:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tlu5ke
        c8+bKTenuSnheTpyPIbGOnRIEDtzI21qiNR+Q=; b=qnMp+4e314BrW58ZdvH+Mc
        RPOflam2LWaJS7uOhL+VYg4xY9Fo4Z8uW6qQ8EAuTSIGuyd/fz5zM8rLq/cDKASE
        2jPh3oWZOSTUPYH5YpsyOUG1Jm2yM618aRx84FTFjeUabrp/uy/vcZE5xxwOF/G9
        nkfdxlfpCkX8TmrYiwkDMyAgFLG2ogQsc3Oxd0wc6cvO6iY4Zc7SwE/8xBm2TDvO
        Exbe69WRkXNJjE8Y9ZOLPGslChEgm/j1OAJf92BEu8LdXaUr6VfH3sC75zpe9y2w
        LMfaSH59z9VKQ2Zps/d0Zs66nETLz7nOd/YPVnP0Y9UV1+8AsbypbdYeXSKlQshQ
        ==
X-ME-Sender: <xms:4iBWYRBeJNKGpmzVFbX8zRZXlQwUIWbeVgLsRNI0ugW2hIe7lxtZSw>
    <xme:4iBWYfiItAS_3PEQVfnryL-dymIRLDYnjZepMw-CrPkd1ulmOVgkjBHklXMczoz50
    2RsB4JVc0mHmFo>
X-ME-Received: <xmr:4iBWYcl57X_G70qoBKuc951tJwFt5i6nsA5vdWRTU2ABj5MXwYo9JbrF3G9r4oEGUaBEW1k7XdC-nHjBnDRcbEUms6TWlQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekgedgudehtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:4iBWYbzctqvH2bQCf1XnFyNXHhbIsl5fxqZPBEzweli8ujCm500jVg>
    <xmx:4iBWYWSowChFmZTS_sa04sJvr1HNV3px_AAVWG31UsH_SUS67Bf-Og>
    <xmx:4iBWYeYmaOaQaC5KB12kq_K3KTc9SejFmjOP8kasp-Eq9G2gFzdI9w>
    <xmx:4iBWYcMOYuMLo1til95ivrsCSB_9rY0kc01dUUJH2eZjodL5E8yq_Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Sep 2021 16:41:05 -0400 (EDT)
Date:   Thu, 30 Sep 2021 23:41:02 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, vadimp@nvidia.com, moshe@nvidia.com,
        popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next 1/7] cmis: Fix CLEI code parsing
Message-ID: <YVYg3rBB1/a2dlxw@shredder>
References: <20210917144043.566049-1-idosch@idosch.org>
 <20210917144043.566049-2-idosch@idosch.org>
 <20210930202133.rspuswnnbnnhlgeb@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930202133.rspuswnnbnnhlgeb@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 10:21:33PM +0200, Michal Kubecek wrote:
> On Fri, Sep 17, 2021 at 05:40:37PM +0300, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > In CMIS, unlike SFF-8636, there is no presence indication for the CLEI
> > code (Common Language Equipment Identification) field. The field is
> > always present, but might not be supported. In which case, "a value of
> > all ASCII 20h (spaces) shall be entered".
> > 
> > Therefore, remove the erroneous check which seems to be influenced from
> > SFF-8636 and only print the string if it is supported and has a non-zero
> > length.
> > 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> >  cmis.c | 8 +++++---
> >  cmis.h | 3 +--
> >  2 files changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/cmis.c b/cmis.c
> > index 1a91e798e4b8..2a48c1a1d56a 100644
> > --- a/cmis.c
> > +++ b/cmis.c
> > @@ -307,6 +307,8 @@ static void cmis_show_link_len(const __u8 *id)
> >   */
> >  static void cmis_show_vendor_info(const __u8 *id)
> >  {
> > +	const char *clei = (const char *)(id + CMIS_CLEI_START_OFFSET);
> > +
> >  	sff_show_ascii(id, CMIS_VENDOR_NAME_START_OFFSET,
> >  		       CMIS_VENDOR_NAME_END_OFFSET, "Vendor name");
> >  	cmis_show_oui(id);
> > @@ -319,9 +321,9 @@ static void cmis_show_vendor_info(const __u8 *id)
> >  	sff_show_ascii(id, CMIS_DATE_YEAR_OFFSET,
> >  		       CMIS_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
> >  
> > -	if (id[CMIS_CLEI_PRESENT_BYTE] & CMIS_CLEI_PRESENT_MASK)
> > -		sff_show_ascii(id, CMIS_CLEI_START_OFFSET,
> > -			       CMIS_CLEI_END_OFFSET, "CLEI code");
> > +	if (strlen(clei) && strcmp(clei, CMIS_CLEI_BLANK))
> > +		sff_show_ascii(id, CMIS_CLEI_START_OFFSET, CMIS_CLEI_END_OFFSET,
> > +			       "CLEI code");
> >  }
> >  
> >  void qsfp_dd_show_all(const __u8 *id)
> 
> Is it safe to assume that the string will be always null terminated?

No. You want to see strnlen() and strncmp() instead?

> Looking at the code below, CMIS_CLEI_BLANK consists of 10 spaces which
> would fill the whole block at offsets 0xBE through 0xC7 with spaces and
> offset 0xC8 is used as CMIS_PWR_CLASS_OFFSET. Also, sff_show_ascii()
> doesn't seem to expect a null terminated string, rather a space padded
> one.
> 
> Michal
> 
> 
> > diff --git a/cmis.h b/cmis.h
> > index 78ee1495bc33..d365252baa48 100644
> > --- a/cmis.h
> > +++ b/cmis.h
> > @@ -34,10 +34,9 @@
> >  #define CMIS_DATE_VENDOR_LOT_OFFSET		0xBC
> >  
> >  /* CLEI Code (Page 0) */
> > -#define CMIS_CLEI_PRESENT_BYTE			0x02
> > -#define CMIS_CLEI_PRESENT_MASK			0x20
> >  #define CMIS_CLEI_START_OFFSET			0xBE
> >  #define CMIS_CLEI_END_OFFSET			0xC7
> > +#define CMIS_CLEI_BLANK				"          "
> >  
> >  /* Cable assembly length */
> >  #define CMIS_CBL_ASM_LEN_OFFSET			0xCA
> > -- 
> > 2.31.1
> > 


