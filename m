Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96722D2DE4
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 17:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfJJPiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 11:38:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35445 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfJJPiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 11:38:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id v8so8481386wrt.2
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 08:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z+Gkaf0QqroJFGWOAVIivpR0uzALr3BZIuYtVcv3prg=;
        b=An1rCjjgNS7CgI92YXRqwtxoR2+VPVfg1jpEa3YMpCkcPk+czOhVxPOPlsUMKybCwd
         6KQhzzj/5+oDRajHiRuX//K1F770WqLEgrVaOq99elMgyel5nd2KkoEhSu6fdvQX8R0/
         j+vlY6OEgscvqn0Oy5NZui094cdrX/NJTs0IfPLi7pDOP4ZuDZkMUv1ZZQSM6FYWqFDo
         v17nUxo0yt5EWpKzmCtNk+TbN/mdpsIU55DYX/5yLHG43sNwJQvLtNmB/59FW+7s8aG7
         U8ZEkwK4tkLMErF5nogUzQs3LiDmGNvP3mZQsYrWbqeIAVKc7z0E9BKro9eKJ0B2z3jO
         cpQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=z+Gkaf0QqroJFGWOAVIivpR0uzALr3BZIuYtVcv3prg=;
        b=bGsbMJTfDxeDJHufp8vOSq4PnEUutQznbcVzM0N49svUdsMzqdU6GZMwt72ET3Nq+i
         jqbQZlDOtpbjrdmkmzU4sMtnLLD2qOl29FJrzguevaSFnMt3FIYQHexENE2e9FVtdW7J
         7ovn9nxwB5JXfOBOtBEVLW1bqAkKx3KXrNfOVbilowMT+4dzqJFdLAjr++6EZv76UzWY
         JU+cB9Mv+ZtcrGGVVWkYQ6q8n8cYEl08adaIEkYdI8e6cJ3wgrVAPfdcXy9V7o/sQ1CY
         8DeW0ldnzJma8lyl+BAOWY+E6IBYQ1chdAoxB4qyiY7X26Fv/q4r1pN+GsWOyjLcZisS
         chGw==
X-Gm-Message-State: APjAAAWk9Owjv1LRx7/cdcB8ITEhE+L34HRPNSgPH9eKCVBD97+PehGd
        PKaubYtzEGYCYrM97LHmdaosGQ==
X-Google-Smtp-Source: APXvYqwZ69806fViMGZKjqZhvNLN0kBd/FTDoA6+GonPedIE2oOd7PHFQQdldx0H/FriUUUdYXA/Ww==
X-Received: by 2002:adf:f9cf:: with SMTP id w15mr9564920wrr.61.1570721876343;
        Thu, 10 Oct 2019 08:37:56 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g11sm6936820wmh.45.2019.10.10.08.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 08:37:55 -0700 (PDT)
Date:   Thu, 10 Oct 2019 17:37:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 14/17] ethtool: set link settings with
 LINKINFO_SET request
Message-ID: <20191010153754.GA2901@nanopsycho>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <aef31ba798d1cfa2ae92d333ad1547f4b528ffa8.1570654310.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aef31ba798d1cfa2ae92d333ad1547f4b528ffa8.1570654310.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 09, 2019 at 10:59:43PM CEST, mkubecek@suse.cz wrote:
>Implement LINKINFO_SET netlink request to set link settings queried by
>LINKINFO_GET message.
>
>Only physical port, phy MDIO address and MDI(-X) control can be set,
>attempt to modify MDI(-X) status and transceiver is rejected.
>
>When any data is modified, ETHTOOL_MSG_LINKINFO_NTF message in the same
>format as reply to LINKINFO_GET request is sent to notify userspace about
>the changes. The same notification is also sent when these settings are
>modified using the ioctl interface.
>

It is a bit confusing and harder to follow when you have set and notify
code in the same patch. Could you please split?

[...]


>+/* LINKINFO_SET */
>+
>+static const struct nla_policy linkinfo_hdr_policy[ETHTOOL_A_HEADER_MAX + 1] = {
>+	[ETHTOOL_A_HEADER_UNSPEC]		= { .type = NLA_REJECT },
>+	[ETHTOOL_A_HEADER_DEV_INDEX]		= { .type = NLA_U32 },
>+	[ETHTOOL_A_HEADER_DEV_NAME]		= { .type = NLA_NUL_STRING,
>+						    .len = IFNAMSIZ - 1 },
>+	[ETHTOOL_A_HEADER_GFLAGS]		= { .type = NLA_U32 },
>+	[ETHTOOL_A_HEADER_RFLAGS]		= { .type = NLA_REJECT },
>+};

This is what I was talking about in the other email. These common attrs
should have common policy and should be parsed by generic netlink code
by default and be available for ethnl_set_linkinfo() in info->attrs.


>+
>+static const struct nla_policy
>+linkinfo_set_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
>+	[ETHTOOL_A_LINKINFO_UNSPEC]		= { .type = NLA_REJECT },
>+	[ETHTOOL_A_LINKINFO_HEADER]		= { .type = NLA_NESTED },
>+	[ETHTOOL_A_LINKINFO_PORT]		= { .type = NLA_U8 },
>+	[ETHTOOL_A_LINKINFO_PHYADDR]		= { .type = NLA_U8 },
>+	[ETHTOOL_A_LINKINFO_TP_MDIX]		= { .type = NLA_REJECT },
>+	[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL]	= { .type = NLA_U8 },
>+	[ETHTOOL_A_LINKINFO_TRANSCEIVER]	= { .type = NLA_REJECT },
>+};
>+
>+int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct nlattr *tb[ETHTOOL_A_LINKINFO_MAX + 1];
>+	struct ethtool_link_ksettings ksettings = {};
>+	struct ethtool_link_settings *lsettings;
>+	struct ethnl_req_info req_info = {};
>+	struct net_device *dev;
>+	bool mod = false;
>+	int ret;
>+
>+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
>+			  ETHTOOL_A_LINKINFO_MAX, linkinfo_set_policy,
>+			  info->extack);

Yeah, genl code should do this parse..


>+	if (ret < 0)
>+		return ret;
>+	ret = ethnl_parse_header(&req_info, tb[ETHTOOL_A_LINKINFO_HEADER],
>+				 genl_info_net(info), info->extack,
>+				 linkinfo_hdr_policy, true);

and pre_doit should do this one.


>+	if (ret < 0)
>+		return ret;
>+	dev = req_info.dev;
>+	if (!dev->ethtool_ops->get_link_ksettings ||
>+	    !dev->ethtool_ops->set_link_ksettings)
>+		return -EOPNOTSUPP;
>+
>+	rtnl_lock();
>+	ret = ethnl_before_ops(dev);
>+	if (ret < 0)
>+		goto out_rtnl;
>+
>+	ret = __ethtool_get_link_ksettings(dev, &ksettings);
>+	if (ret < 0) {
>+		if (info)
>+			GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
>+		goto out_ops;
>+	}
>+	lsettings = &ksettings.base;
>+
>+	ethnl_update_u8(&lsettings->port, tb[ETHTOOL_A_LINKINFO_PORT], &mod);
>+	ethnl_update_u8(&lsettings->phy_address, tb[ETHTOOL_A_LINKINFO_PHYADDR],
>+			&mod);
>+	ethnl_update_u8(&lsettings->eth_tp_mdix_ctrl,
>+			tb[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL], &mod);
>+
>+	ret = 0;
>+	if (mod) {

	if (!mod)
		goto out_ops;

?


>+		ret = dev->ethtool_ops->set_link_ksettings(dev, &ksettings);
>+		if (ret < 0)
>+			GENL_SET_ERR_MSG(info, "link settings update failed");
>+		else
>+			ethtool_notify(dev, ETHTOOL_MSG_LINKINFO_NTF, NULL);
>+	}
>+
>+out_ops:
>+	ethnl_after_ops(dev);
>+out_rtnl:
>+	rtnl_unlock();
>+	dev_put(dev);
>+	return ret;
>+}
>diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
>index dc52d912e0dd..5b9d12656e97 100644
>--- a/net/ethtool/netlink.c
>+++ b/net/ethtool/netlink.c
>@@ -603,6 +603,11 @@ static int ethnl_get_done(struct netlink_callback *cb)
> 
> static const struct get_request_ops *ethnl_std_notify_to_ops(unsigned int cmd)
> {
>+	switch (cmd) {
>+	case ETHTOOL_MSG_LINKINFO_NTF:
>+		return &linkinfo_request_ops;
>+	};
>+
> 	WARN_ONCE(1, "unexpected notification type %u\n", cmd);
> 	return NULL;
> }
>@@ -683,6 +688,7 @@ typedef void (*ethnl_notify_handler_t)(struct net_device *dev, unsigned int cmd,
> 				       const void *data);
> 
> static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
>+	[ETHTOOL_MSG_LINKINFO_NTF]	= ethnl_std_notify,

Correct me if I'm wrong, but this is the only notification I found in
this patchset. Do you expect other then ethnl_std_notify() handler?
Bacause otherwise this can ba simplified down to just a single table
similar you have for GET.


> };
> 
> void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
>@@ -717,6 +723,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
> 		.dumpit	= ethnl_get_dumpit,
> 		.done	= ethnl_get_done,
> 	},
>+	{
>+		.cmd	= ETHTOOL_MSG_LINKINFO_SET,
>+		.flags	= GENL_UNS_ADMIN_PERM,
>+		.doit	= ethnl_set_linkinfo,
>+	},
> };
> 
> static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
>diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
>index 23e82a4dd265..ca136dd7ea02 100644
>--- a/net/ethtool/netlink.h
>+++ b/net/ethtool/netlink.h
>@@ -350,4 +350,6 @@ struct get_request_ops {
> extern const struct get_request_ops strset_request_ops;
> extern const struct get_request_ops linkinfo_request_ops;
> 
>+int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
>+
> #endif /* _NET_ETHTOOL_NETLINK_H */
>-- 
>2.23.0
>
