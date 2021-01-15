Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362812F8358
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 19:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732636AbhAOSKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 13:10:55 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:51023 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725818AbhAOSKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 13:10:55 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 207BCE0A;
        Fri, 15 Jan 2021 13:09:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 15 Jan 2021 13:09:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=tQxS8y
        EIWpD/O4/tbo43HNGW5K3jU4TIEXC6qjpsYwI=; b=lC1eD5qZ6hTcV6q+ofkDJj
        ve9qytloL/iUpoCW+yPP4xv73d51bg356j7jp3aeBsHFf/Wz+B8kZxbgA3oXY2MA
        GW9Bjn9xs1t9Fe0brDMFyZWHDR20gtmZMyxqBAUgZ1+ID6JyvjrQgMYLlGQJ6HKw
        Oqf255sf9tNjFT6zYr5CHSat8G4vuzzaNm96nplNnoq2hOsM74bFs6qU5CS/gW1x
        dPu3gz4d5lrUKfeQXcxCgWzlWP4gjM+vcf7TBDT0UnClxGmnMrisdRooaR8SlsUt
        +x1vZ5Qdm+4tI4sHnXyEG7Wo1m0G5TWu0iVCooe+QR0BZiw57YoABud8uzCR2lIA
        ==
X-ME-Sender: <xms:a9oBYPiMohR6oTKFFIzYLvzrRfEhiE9VB34dI3zJTwI6BO68zGfkug>
    <xme:a9oBYMDxciCvD3UCeqMuOaD7ssanF8KbUb_MhUkbkgvKbuUDmanV6GNo51xZdXUUV
    21m37TzVDRV4-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddvgdekhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:a9oBYPHGg2q-dV86Me-wD2ncQDEHN2_fqVrbLqdSm07YTP7V6zqMWA>
    <xmx:a9oBYMSm52eDwbIqzKTj9ppJmPwHF7DnjDdJIfLz6TJwP4mle8Arpw>
    <xmx:a9oBYMzdaU44R6ZH77k3Prq1hxxTLFqWZTdfYSmM3j1NhCJh4tph9Q>
    <xmx:bNoBYI_R0HJtERVO-OixhhPH_F70zJPTKVsOVvpefAzsLa06R8F5Ig>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 12393240067;
        Fri, 15 Jan 2021 13:09:46 -0500 (EST)
Date:   Fri, 15 Jan 2021 20:09:44 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 02/10] devlink: implement line card
 provisioning
Message-ID: <20210115180944.GB2074023@shredder.lan>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113121222.733517-3-jiri@resnulli.us>
 <20210115160319.GC2064789@shredder.lan>
 <20210115165157.GO3565223@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115165157.GO3565223@nanopsycho.orion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 05:51:57PM +0100, Jiri Pirko wrote:
> Fri, Jan 15, 2021 at 05:03:19PM CET, idosch@idosch.org wrote:
> >On Wed, Jan 13, 2021 at 01:12:14PM +0100, Jiri Pirko wrote:
> >> From: Jiri Pirko <jiri@nvidia.com>
> >> 
> >> In order to be able to configure all needed stuff on a port/netdevice
> >> of a line card without the line card being present, introduce line card
> >> provisioning. Basically provisioning will create a placeholder for
> >> instances (ports/netdevices) for a line card type.
> >> 
> >> Allow the user to query the supported line card types over line card
> >> get command. Then implement two netlink commands to allow user to
> >> provision/unprovision the line card with selected line card type.
> >> 
> >> On the driver API side, add provision/unprovision ops and supported
> >> types array to be advertised. Upon provision op call, the driver should
> >> take care of creating the instances for the particular line card type.
> >> Introduce provision_set/clear() functions to be called by the driver
> >> once the provisioning/unprovisioning is done on its side.
> >> 
> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> >> ---
> >>  include/net/devlink.h        |  31 +++++++-
> >>  include/uapi/linux/devlink.h |  17 +++++
> >>  net/core/devlink.c           | 141 ++++++++++++++++++++++++++++++++++-
> >>  3 files changed, 185 insertions(+), 4 deletions(-)
> >> 
> >> diff --git a/include/net/devlink.h b/include/net/devlink.h
> >> index 67c2547d5ef9..854abd53e9ea 100644
> >> --- a/include/net/devlink.h
> >> +++ b/include/net/devlink.h
> >> @@ -139,10 +139,33 @@ struct devlink_port {
> >>  	struct mutex reporters_lock; /* Protects reporter_list */
> >>  };
> >>  
> >> +struct devlink_linecard_ops;
> >> +
> >>  struct devlink_linecard {
> >>  	struct list_head list;
> >>  	struct devlink *devlink;
> >>  	unsigned int index;
> >> +	const struct devlink_linecard_ops *ops;
> >> +	void *priv;
> >> +	enum devlink_linecard_state state;
> >> +	const char *provisioned_type;
> >> +};
> >> +
> >> +/**
> >> + * struct devlink_linecard_ops - Linecard operations
> >> + * @supported_types: array of supported types of linecards
> >> + * @supported_types_count: number of elements in the array above
> >> + * @provision: callback to provision the linecard slot with certain
> >> + *	       type of linecard
> >> + * @unprovision: callback to unprovision the linecard slot
> >> + */
> >> +struct devlink_linecard_ops {
> >> +	const char **supported_types;
> >> +	unsigned int supported_types_count;
> >> +	int (*provision)(struct devlink_linecard *linecard, void *priv,
> >> +			 u32 type_index, struct netlink_ext_ack *extack);
> >> +	int (*unprovision)(struct devlink_linecard *linecard, void *priv,
> >> +			   struct netlink_ext_ack *extack);
> >>  };
> >>  
> >>  struct devlink_sb_pool_info {
> >> @@ -1414,9 +1437,13 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 contro
> >>  				   u16 pf, bool external);
> >>  void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 controller,
> >>  				   u16 pf, u16 vf, bool external);
> >> -struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
> >> -						 unsigned int linecard_index);
> >> +struct devlink_linecard *
> >> +devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
> >> +			const struct devlink_linecard_ops *ops, void *priv);
> >>  void devlink_linecard_destroy(struct devlink_linecard *linecard);
> >> +void devlink_linecard_provision_set(struct devlink_linecard *linecard,
> >> +				    u32 type_index);
> >> +void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
> >>  int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
> >>  			u32 size, u16 ingress_pools_count,
> >>  			u16 egress_pools_count, u16 ingress_tc_count,
> >> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> >> index e5ed0522591f..4111ddcc000b 100644
> >> --- a/include/uapi/linux/devlink.h
> >> +++ b/include/uapi/linux/devlink.h
> >> @@ -131,6 +131,9 @@ enum devlink_command {
> >>  	DEVLINK_CMD_LINECARD_NEW,
> >>  	DEVLINK_CMD_LINECARD_DEL,
> >>  
> >> +	DEVLINK_CMD_LINECARD_PROVISION,
> >> +	DEVLINK_CMD_LINECARD_UNPROVISION,
> >
> >I do not really see the point in these two commands. Better extend
> >DEVLINK_CMD_LINECARD_SET to carry these attributes.
> 
> Yeah, I was thinking about that. Not sure it is correct though. This is
> single purpose command. It really does not change "an attribute" as the
> "_SET" commands are usually doing. Consider extension of "_SET" by other
> attributes. Then it looks wrong.

It is setting the type of the linecard, which is an attribute of the
linecard.

> 
> 
> >
> >> +
> >>  	/* add new commands above here */
> >>  	__DEVLINK_CMD_MAX,
> >>  	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
> >> @@ -329,6 +332,17 @@ enum devlink_reload_limit {
> >>  
> >>  #define DEVLINK_RELOAD_LIMITS_VALID_MASK (_BITUL(__DEVLINK_RELOAD_LIMIT_MAX) - 1)
> >>  
> >> +enum devlink_linecard_state {
> >> +	DEVLINK_LINECARD_STATE_UNSPEC,
> >> +	DEVLINK_LINECARD_STATE_UNPROVISIONED,
> >> +	DEVLINK_LINECARD_STATE_UNPROVISIONING,
> >> +	DEVLINK_LINECARD_STATE_PROVISIONING,
> >
> >Can you explain why these two states are necessary? Any reason the
> >provision operation can't be synchronous? This is somewhat explained in
> >patch #8, but it should really be explained here. Changelog says:
> >
> >"To avoid deadlock and to mimic actual HW flow, use workqueue
> >to add/del ports during provisioning as the port add/del calls
> >devlink_port_register/unregister() which take devlink mutex."
> >
> >The deadlock is not really a reason to have these states.
> 
> It is, need to avoid recursice locking
> 
> >'DEVLINK_CMD_PORT_SPLIT' also calls devlink_port_register() /
> >devlink_port_unregister() and the deadlock is solved by:
> >
> >'internal_flags = DEVLINK_NL_FLAG_NO_LOCK'
> 
> Yeah, however, there, the port_index is passed down to the driver, not
> the actual object pointer. That's why it can be done like that.
> 
> >
> >A hardware flow the requires it is something else...
> 
> Hardware flow in case of Spectrum is async too.

OK, so the changelog needs to state that these states are necessary
because the nature of linecard provisioning is asynchronous.

> 
> 
> >
> >> +	DEVLINK_LINECARD_STATE_PROVISIONED,
> >> +
> >> +	__DEVLINK_LINECARD_STATE_MAX,
> >> +	DEVLINK_LINECARD_STATE_MAX = __DEVLINK_LINECARD_STATE_MAX - 1
> >> +};
> >> +
> >>  enum devlink_attr {
> >>  	/* don't change the order or add anything between, this is ABI! */
> >>  	DEVLINK_ATTR_UNSPEC,
> >> @@ -535,6 +549,9 @@ enum devlink_attr {
> >>  	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
> >>  
> >>  	DEVLINK_ATTR_LINECARD_INDEX,		/* u32 */
> >> +	DEVLINK_ATTR_LINECARD_STATE,		/* u8 */
> >> +	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
> >> +	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
> >>  
> >>  	/* add new attributes above here, update the policy in devlink.c */
> >>  
> >> diff --git a/net/core/devlink.c b/net/core/devlink.c
> >> index 564e921133cf..434eecc310c3 100644
> >> --- a/net/core/devlink.c
> >> +++ b/net/core/devlink.c
> >> @@ -1192,7 +1192,9 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
> >>  				    u32 seq, int flags,
> >>  				    struct netlink_ext_ack *extack)
> >>  {
> >> +	struct nlattr *attr;
> >>  	void *hdr;
> >> +	int i;
> >>  
> >>  	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
> >>  	if (!hdr)
> >> @@ -1202,6 +1204,22 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
> >>  		goto nla_put_failure;
> >>  	if (nla_put_u32(msg, DEVLINK_ATTR_LINECARD_INDEX, linecard->index))
> >>  		goto nla_put_failure;
> >> +	if (nla_put_u8(msg, DEVLINK_ATTR_LINECARD_STATE, linecard->state))
> >> +		goto nla_put_failure;
> >> +	if (linecard->state >= DEVLINK_LINECARD_STATE_PROVISIONED &&
> >
> >This assumes that every state added after provisioned should report the
> >type. Better to check for the specific states
> 
> Yes, that is correct assumption.

It is correct now, but what if tomorrow someone adds a new state? It
can't be added before the provisioned state because it will break uapi.

> 
> 
> >
> >> +	    nla_put_string(msg, DEVLINK_ATTR_LINECARD_TYPE,
> >> +			   linecard->provisioned_type))
> >> +		goto nla_put_failure;
