Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB7D22FBC4
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgG0WCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:02:33 -0400
Received: from mout.gmx.net ([212.227.17.20]:52055 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbgG0WCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:02:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1595887344;
        bh=AYlC2xyDHynf8fR8+g+VbwM9mmDG4TM/WCGqB1doPFA=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=XYdZk/zW7vcWRQgeWvcQvQ2BY4dr10RsvJwS0ZoPCXPcSAsr/kmz2s6XckGfOyyqs
         ZUA2jlfuhx/Mop73tLRUnh5QYBYkBPw72Bg1elsWVg6Mb4HDJ07KWeX46VpOxiuCoY
         6xn5gKZFa2Rp3OljrLyKm6OyRmdgY2+JOjOuHCtU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from gmx.fr ([131.100.39.21]) by mail.gmx.com (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MMofc-1kGbaV1xp6-00Ij2a; Tue, 28
 Jul 2020 00:02:23 +0200
Date:   Mon, 27 Jul 2020 18:02:15 -0400
From:   Jamie Gloudon <jamie.gloudon@gmx.fr>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        netdev@vger.kernel.org
Subject: Re: [ethtool] ethtool: fix netlink bitmasks when sent as NOMASK
Message-ID: <20200727220215.GA1886@gmx.fr>
References: <20200727214700.5915-1-jacob.e.keller@intel.com>
 <e0b0dd6e-de26-b443-d688-90ab9beb5403@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0b0dd6e-de26-b443-d688-90ab9beb5403@intel.com>
X-Provags-ID: V03:K1:8LPmPMiizbRkbLzYjshyAk0YbO55XXDMzZMX7/FWIkBtL/46s3v
 f3nQmnrI/AEIuSzoJvZM2C90fymwEXre4GRSmibl1F03/UtcErZeqt6EtdyblQLsTfW3Px0
 D99HDCIspuJlthXbdJmvBsY4dcr/Y/GPsDkU6iV+/jnx9aHDHivG41J68OoAHJh5nqMenHl
 CBT95hmMO3VXThjCVOKKw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tn+oCMJ/zmE=:67Cutg2HLfp+qYUenZC3Zx
 SRFsu7Gjqh8U/hM8jvxhlx3woAbOd5FsMfM1pLTo65jw5igZHg8STIuEEP2/poBNu9JtmzwVI
 YLLMihIavpIYy2Lf/wUujKPtWcWCTSSAGVDw1aQP6+r23nHJMRbnODWZr32IxBS3rE/UnpK+R
 c53sALyu/q+Op2iNkSHgyBJ9R3QLlu4uKpSFU2ayB+2whv0sFkJCsIFQLEqfY3gPuRgl1hd9u
 l/Dmp/AY3WeuUjRWssMqdV7ZVmpfPMgxp2HvV5jAevpilS/R5wePqrUbntOo4qyJs9X6XgjYt
 LlklLV29Glv1W0sqMwNhtBQqbFYl11II9bxwtnEFkY2LR1RswoN6+E0XaXzEyd1ixN9/Acg24
 40jYUk0u66sFzqRM1rMJgKsYEAGe5Lgv1xkd/B7iTYmlnGTzzBvRayugcB/uvzzLT+J6MoWPf
 jj7aUdzjpjocb14RvA2pfKbWm600sn2W3OY/5YUp4QQmUfue65J3CwRWdCxR5Ul/XRN6G14or
 dcVPhlgNGKqFCaoxBvK0opvA+1ioua+BOLkfYPHPqAvrDKDZD009AZjWa7cVYWNRchqY33/oG
 o7N040wvwEubW2l4Sf4wy72uhema18ZKhQoSYhomFmlSihItO7tGJkh7Sw//alaPN8IykpzK6
 yl3frJChh+kQAbQdxIhgAi3ybQnidhnDQspUVC+baCdgZUmHPhMRIZxKzSz4UGM9Rfx3Swh5t
 vzMDrlnVTZ3j9A1E+22XNpJArGR88bRCqYXZ+hBJfiNitWDHHT82i62sNE9p34mAJuEqp+uMs
 c+5JJX/ZaIwZE+dEYxSHV3O1oZU42c/qi+1cVfzWNzcJQGAAdwurjqQBGoHHujQfVb1E2GR2k
 rugH3jJI9sEPjhc5+zG06Wvcj90mrsXBpHO0EtDt0ZQXME/Nh1ukjSe4RgRx5i6X0AdgXb83O
 gGKA+fwKaOFKv5OlJvqi7QD/97BK167Jv2wIOeTdbo1ngJ+wC9ttNbwo6Lk24lL/k6DAGtuyb
 lqGJ0FAcK9CyC0VKnXbtu4J789stPvjDSw11/XdEoeJirNvFNUFLjNNyOOsPX5JQ5N/7gzEUk
 YWD8oYKmEK0n9MggKrv0iedHVa33j73zb05cPzf5mVGRnAdoHxZfNuBdlFC4nVqX4hB3hOtkj
 jXXF4OGEkMR1c9ISNtS6QgzG8Q9MACRqB0OoNopmnGRBiYyHxSY7NRAEVXWG1wd3BRkiQZbVT
 5AZZDMJv9KMfLY9jOzimDOizTrorSAMpraKG5zQ==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 02:51:28PM -0700, Jacob Keller wrote:
>
>
> On 7/27/2020 2:47 PM, Jacob Keller wrote:
> > The ethtool netlink API can send bitsets without an associated bitmask=
.
> > These do not get displayed properly, because the dump_link_modes, and
> > bitset_get_bit to not check whether the provided bitset is a NOMASK
> > bitset. This results in the inability to display peer advertised link
> > modes.
> >
> > The dump_link_modes and bitset_get_bit functions are designed so they
> > can print either the values or the mask. For a nomask bitmap, this
> > doesn't make sense. There is no mask.
> >
> > Modify dump_link_modes to check ETHTOOL_A_BITSET_NOMASK. For compact
> > bitmaps, always check and print the ETHTOOL_A_BITSET_VALUE bits,
> > regardless of the request to display the mask or the value. For full
> > size bitmaps, the set of provided bits indicates the valid values,
> > without using ETHTOOL_A_BITSET_VALUE fields. Thus, do not skip printin=
g
> > bits without this attribute if nomask is set. This essentially means
> > that dump_link_modes will treat a NOMASK bitset as having a mask
> > equivalent to all of its set bits.
> >
> > For bitset_get_bit, also check for ETHTOOL_A_BITSET_NOMASK. For compac=
t
> > bitmaps, always use ETHTOOL_A_BITSET_BIT_VALUE as in dump_link_modes.
> > For full bitmaps, if nomask is set, then always return true of the bit
> > is in the set, rather than only if it provides an
> > ETHTOOL_A_BITSET_BIT_VALUE. This will then correctly report the set
> > bits.
> >
> > This fixes display of link partner advertised fields when using the
> > netlink API.
> >
> > Reported-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
> > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>
> Andrew, could you kindly test this in your setup? I believe it will
> fully resolve the issue.
>
> Michal, I think this is complete based on the docs in
> ethtool-netlink.rst and some tests. Any further insight?
>
> Thanks,
> Jake
>
> > ---
> >  netlink/bitset.c   | 9 ++++++---
> >  netlink/settings.c | 8 +++++---
> >  2 files changed, 11 insertions(+), 6 deletions(-)
> >
> > diff --git a/netlink/bitset.c b/netlink/bitset.c
> > index 130bcdb5b52c..ba5d3ea77ff7 100644
> > --- a/netlink/bitset.c
> > +++ b/netlink/bitset.c
> > @@ -50,6 +50,7 @@ bool bitset_get_bit(const struct nlattr *bitset, boo=
l mask, unsigned int idx,
> >  	DECLARE_ATTR_TB_INFO(bitset_tb);
> >  	const struct nlattr *bits;
> >  	const struct nlattr *bit;
> > +	bool nomask;
> >  	int ret;
> >
> >  	*retptr =3D 0;
> > @@ -57,8 +58,10 @@ bool bitset_get_bit(const struct nlattr *bitset, bo=
ol mask, unsigned int idx,
> >  	if (ret < 0)
> >  		goto err;
> >
> > -	bits =3D mask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
> > -		      bitset_tb[ETHTOOL_A_BITSET_VALUE];
> > +	nomask =3D bitset_tb[ETHTOOL_A_BITSET_NOMASK];
> > +
> > +	bits =3D mask && !nomask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
> > +		                 bitset_tb[ETHTOOL_A_BITSET_VALUE];
> >  	if (bits) {
> >  		const uint32_t *bitmap =3D
> >  			(const uint32_t *)mnl_attr_get_payload(bits);
> > @@ -87,7 +90,7 @@ bool bitset_get_bit(const struct nlattr *bitset, boo=
l mask, unsigned int idx,
> >
> >  		my_idx =3D mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_BIT_INDEX]);
> >  		if (my_idx =3D=3D idx)
> > -			return mask || tb[ETHTOOL_A_BITSET_BIT_VALUE];
> > +			return mask || nomask || tb[ETHTOOL_A_BITSET_BIT_VALUE];
> >  	}
> >
> >  	return false;
> > diff --git a/netlink/settings.c b/netlink/settings.c
> > index 35ba2f5dd6d5..29557653336e 100644
> > --- a/netlink/settings.c
> > +++ b/netlink/settings.c
> > @@ -280,9 +280,11 @@ int dump_link_modes(struct nl_context *nlctx, con=
st struct nlattr *bitset,
> >  	const struct nlattr *bit;
> >  	bool first =3D true;
> >  	int prev =3D -2;
> > +	bool nomask;
> >  	int ret;
> >
> >  	ret =3D mnl_attr_parse_nested(bitset, attr_cb, &bitset_tb_info);
> > +	nomask =3D bitset_tb[ETHTOOL_A_BITSET_NOMASK];
> >  	bits =3D bitset_tb[ETHTOOL_A_BITSET_BITS];
> >  	if (ret < 0)
> >  		goto err_nonl;
> > @@ -297,8 +299,8 @@ int dump_link_modes(struct nl_context *nlctx, cons=
t struct nlattr *bitset,
> >  			goto err_nonl;
> >  		lm_strings =3D global_stringset(ETH_SS_LINK_MODES,
> >  					      nlctx->ethnl2_socket);
> > -		bits =3D mask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
> > -			      bitset_tb[ETHTOOL_A_BITSET_VALUE];
> > +		bits =3D mask && !nomask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
> > +			                 bitset_tb[ETHTOOL_A_BITSET_VALUE];
> >  		ret =3D -EFAULT;
> >  		if (!bits || !bitset_tb[ETHTOOL_A_BITSET_SIZE])
> >  			goto err_nonl;
> > @@ -354,7 +356,7 @@ int dump_link_modes(struct nl_context *nlctx, cons=
t struct nlattr *bitset,
> >  		if (!tb[ETHTOOL_A_BITSET_BIT_INDEX] ||
> >  		    !tb[ETHTOOL_A_BITSET_BIT_NAME])
> >  			goto err;
> > -		if (!mask && !tb[ETHTOOL_A_BITSET_BIT_VALUE])
> > +		if (!mask && !nomask && !tb[ETHTOOL_A_BITSET_BIT_VALUE])
> >  			continue;
> >
> >  		idx =3D mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_BIT_INDEX]);
> >

I can confirm that your patch works. As you can see below:

	Link partner advertised pause frame use: Symmetric Receive-only
        Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: No

You can tag this patch Tested-by me. Thanks!

Regards,
Jamie Gloudon
