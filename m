Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E654D4225E2
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 14:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbhJEMF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 08:05:59 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:36697 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233817AbhJEMF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 08:05:58 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 281E7580E35;
        Tue,  5 Oct 2021 08:04:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 05 Oct 2021 08:04:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/Kg960
        rQQ2+mJuhrw+IRZH3uSRcTAliaraMTp39Pe0A=; b=iuOlI3HBwKBaZprZJGaOZ2
        3sxQYdLgtal3qnoNlM7XoG8b7DCDHgJbullfJ3c2lyOaGniCsHunlSHDVO659V5c
        AbQIAgAgyX4tW+wX+Q3O44+tXUsnGFfvAl3ydoFlUoCQkaY9HyGDuhtoRgX/b6cl
        WJ6I/uNfq6OaOl5J3ZOPFpWm0VD/KbdKzEWURsimUe1v3+2Op/tomL2NbV4r55P2
        zA1jnxi8C6WXB4yT/SrRLw1bGm5kb7CHgURp7+ZO9HlzBdZQ6SJ/2pYYnIkjCerM
        QbvmOL+JclgbuJaVHyRTXEwl8E186MaWm5iqYCuZ5UbzkkidRcU/kFv88kQ+ywGw
        ==
X-ME-Sender: <xms:Nj9cYdzVn_egYYA3HIeUxidH0jdPJxMfQEf0p3OpypHEzHgd1IPI0A>
    <xme:Nj9cYdTS9z90xX0khLs4i0i11CeWN4s44KYAsAvk89wZ7DGD-VhYGLIQSKdyPqXk3
    uIomZy2pV22Dt8>
X-ME-Received: <xmr:Nj9cYXWUvw4T-EIWeDxheNEWNqVUD5Iu9-T_OHOp-PC9eN5BnuHfQubZUExP5z0VjAvCxjBbfixirqCMnPL099Tu-Q8cjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelgedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepgfevgfevueduueffieffheeifffgje
    elvedtteeuteeuffekvefggfdtudfgkeevnecuffhomhgrihhnpehkvghrnhgvlhdrohhr
    ghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Nj9cYfi_sv0lxGInSv21ULqfbD0J1OTJzQCGy-c348Hm9vuwUyoQyQ>
    <xmx:Nj9cYfBQeOKQIgxQ9n_cGHkkwi6nYyfXSR7alcyXYdshApO2TGtt-Q>
    <xmx:Nj9cYYKyGMSCRYLkgacWeFQegzT33mI1ha6nKFR6je9gJUsnJI_7wg>
    <xmx:Nz9cYT2EgJre0TS8Vfig9llmn7V_ImwLqhpfBrmBfrS5_JJdagFizQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 Oct 2021 08:04:05 -0400 (EDT)
Date:   Tue, 5 Oct 2021 15:04:02 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/6] ethtool: Add ability to control transceiver
 modules' power mode
Message-ID: <YVw/MluEOlQjQRr7@shredder>
References: <20211003073219.1631064-1-idosch@idosch.org>
 <20211003073219.1631064-2-idosch@idosch.org>
 <20211004180135.55759be4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YVv3UARMHU8HZTfz@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVv3UARMHU8HZTfz@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 09:57:25AM +0300, Ido Schimmel wrote:
> On Mon, Oct 04, 2021 at 06:01:35PM -0700, Jakub Kicinski wrote:
> > On Sun,  3 Oct 2021 10:32:14 +0300 Ido Schimmel wrote:
> > > From: Ido Schimmel <idosch@nvidia.com>
> > > 
> > > Add a pair of new ethtool messages, 'ETHTOOL_MSG_MODULE_SET' and
> > > 'ETHTOOL_MSG_MODULE_GET', that can be used to control transceiver
> > > modules parameters and retrieve their status.
> > 
> > Acked-by: Jakub Kicinski <kuba@kernel.org>
> 
> Thanks!
> 
> > 
> > Couple of take it or leave it comments again, if you prefer to leave as
> > is that's fine.
> 
> I'll make whatever changes we conclude are necessary. See below.
> 
> > 
> > > +enum ethtool_module_power_mode_policy {
> > > +	ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH,
> > > +	ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO,
> > > +};
> > 
> > I see you left this starting from 0, and we still need a valid bit,
> > granted just internal to the core.
> 
> I was under the impression that we were only talking about the power
> mode itself (which can be invalid if a module is unplugged), but not the
> policy [1]. I did change that like we discussed.
> 
> [1] https://lore.kernel.org/netdev/YSYmFEDWJIu6eDvR@shredder/
> 
> > 
> > Would we not need a driver-facing valid bit later on when we extend 
> > the module API to control more params?
> 
> To keep the driver-facing API simple I want to have different ethtool
> operations for different parameters (like rtnetlink and ndos). So, if a
> driver does not support a parameter, the operation will not be
> implemented and the attributes will not be dumped.
> 
> > Can't there be drivers which implement power but don't support the
> > mode policy?
> 
> I don't really see how. The policy is a host attribute (not module)
> determining how the host configures the power mode of the module. It
> always exists, but can be fixed.
> 
> Do you still think we should make the change below?
> 
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 1b126e8b5269..a2223b685451 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -721,7 +721,7 @@ enum ethtool_stringset {
>   *     administratively down.
>   */
>  enum ethtool_module_power_mode_policy {
> -       ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH,
> +       ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH = 1,
>         ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO,
>  };

I read your reply again about "still need a valid bit, granted just
internal to the core". My confusion was that I thought only the valid
bit in the driver-facing API bothered you, but you actually wanted me to
remove all of them.

How about the below (compile tested)?

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 1b126e8b5269..a2223b685451 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -721,7 +721,7 @@ enum ethtool_stringset {
  *	administratively down.
  */
 enum ethtool_module_power_mode_policy {
-	ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH,
+	ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH = 1,
 	ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO,
 };
 
diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index 254ac84f9728..5d430b2bb20a 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -13,7 +13,6 @@ struct module_req_info {
 struct module_reply_data {
 	struct ethnl_reply_data	base;
 	struct ethtool_module_power_mode_params power;
-	u8 power_valid:1;
 };
 
 #define MODULE_REPDATA(__reply_base) \
@@ -30,18 +29,11 @@ static int module_get_power_mode(struct net_device *dev,
 				 struct netlink_ext_ack *extack)
 {
 	const struct ethtool_ops *ops = dev->ethtool_ops;
-	int ret;
 
 	if (!ops->get_module_power_mode)
 		return 0;
 
-	ret = ops->get_module_power_mode(dev, &data->power, extack);
-	if (ret < 0)
-		return ret;
-
-	data->power_valid = true;
-
-	return 0;
+	return ops->get_module_power_mode(dev, &data->power, extack);
 }
 
 static int module_prepare_data(const struct ethnl_req_info *req_base,
@@ -72,10 +64,10 @@ static int module_reply_size(const struct ethnl_req_info *req_base,
 	struct module_reply_data *data = MODULE_REPDATA(reply_base);
 	int len = 0;
 
-	if (data->power_valid)
+	if (data->power.policy)
 		len += nla_total_size(sizeof(u8));	/* _MODULE_POWER_MODE_POLICY */
 
-	if (data->power_valid && data->power.mode)
+	if (data->power.mode)
 		len += nla_total_size(sizeof(u8));	/* _MODULE_POWER_MODE */
 
 	return len;
@@ -87,12 +79,12 @@ static int module_fill_reply(struct sk_buff *skb,
 {
 	const struct module_reply_data *data = MODULE_REPDATA(reply_base);
 
-	if (data->power_valid &&
+	if (data->power.policy &&
 	    nla_put_u8(skb, ETHTOOL_A_MODULE_POWER_MODE_POLICY,
 		       data->power.policy))
 		return -EMSGSIZE;
 
-	if (data->power_valid && data->power.mode &&
+	if (data->power.mode &&
 	    nla_put_u8(skb, ETHTOOL_A_MODULE_POWER_MODE, data->power.mode))
 		return -EMSGSIZE;
 
@@ -116,7 +108,8 @@ const struct ethnl_request_ops ethnl_module_request_ops = {
 const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1] = {
 	[ETHTOOL_A_MODULE_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_MODULE_POWER_MODE_POLICY] =
-		NLA_POLICY_MAX(NLA_U8, ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO),
+		NLA_POLICY_RANGE(NLA_U8, ETHTOOL_MODULE_POWER_MODE_HIGH,
+				 ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO),
 };
 
 static int module_set_power_mode(struct net_device *dev, struct nlattr **tb,

