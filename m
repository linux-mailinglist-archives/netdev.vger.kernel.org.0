Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB3CD2DA9
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 17:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfJJP0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 11:26:06 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35556 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfJJP0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 11:26:03 -0400
Received: by mail-wr1-f65.google.com with SMTP id v8so8431701wrt.2
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 08:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4KtpyJcZymMDldmeqsuGE5WoW9tQnlMUYqvVj3l3rIE=;
        b=GFYqlOXdzrwPAyel1BaDfJev7DNqRpkIRadg+7l1w/DTWcBEtewg5uv6e5wu9aDBlk
         ZxrZcisq0IwOpa48yRTfgn8LgeJdI9MIGinoZA7gOpP7Lf+yl8GimEoa4j/Lkf9ArSIK
         G3SpIH8zvJJmoPPP6TZYDj6VAcbC/3LnYX//iRu6cS6CRw4SuKPet/VRcMUEKOU6UPDs
         Smhl1vwUqhCfXypJr8QqaevLLrDeTlCm1PHQUZGkA6swbv/S1tb18vCne91Z7OMuihg3
         3sOLbqa2la6QfR8phsyB9g1DHGMzbuaqNJ3cbw4PXxM0JKfiQYSwsSKVRpiM9/IicyxU
         5DKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4KtpyJcZymMDldmeqsuGE5WoW9tQnlMUYqvVj3l3rIE=;
        b=NkLxErFZXwlb329ArEuXgeBNle1gjcRC4t1dIpn5NH2xm1ILszcPCE08Uj/E+ERB6x
         SzNpHin1MTheJ0gau+lqoCD5azD5aOFjcb4QfyOJ/eIi+ZgdBNXhcEvbIuDKe/BqDyjE
         9bm9OVvIScjuo1UidRp6HTtU9vrOLHLHlbpXqcz3ViNwwDlYL3oZZ1xALkkjAeA5nO+e
         7c91+/LEXPmCn6tQuNZx+9Lew549NPWG2EtOXeRaAUh4O/FKGk667Zbi3aKWg5tI/6BN
         tC7UsXd3P6rgA7zd6bFA0Cr6ldW0PN1CGFOjEdTCMtoB9W88832ED6CYeIIhKvchUpOZ
         zERw==
X-Gm-Message-State: APjAAAVz6zhwsHBCd8hRIvEAqdzsmQTyLojqihJFDczTyMZIqC2rtB/S
        sbkw0ljkEcUAcgd/qIhn6EAuFdeEZ54=
X-Google-Smtp-Source: APXvYqyop/uFFLhsM755cqKYP6Lgxlm8Qp3ur3GS/kE9OtX1EgWsuVUAVfrrHfitxhPgWWFfUatkAw==
X-Received: by 2002:a05:6000:354:: with SMTP id e20mr6255987wre.383.1570721161065;
        Thu, 10 Oct 2019 08:26:01 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w18sm6903683wmc.9.2019.10.10.08.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 08:26:00 -0700 (PDT)
Date:   Thu, 10 Oct 2019 17:25:59 +0200
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
Subject: Re: [PATCH net-next v7 13/17] ethtool: add standard notification
 handler
Message-ID: <20191010152559.GA2994@nanopsycho>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <ac2fef494116db9d4679f4501f1be6a7898ef724.1570654310.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac2fef494116db9d4679f4501f1be6a7898ef724.1570654310.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 09, 2019 at 10:59:40PM CEST, mkubecek@suse.cz wrote:
>The ethtool netlink notifications have the same format as related GET
>replies so that if generic GET handling framework is used to process GET
>requests, its callbacks and instance of struct get_request_ops can be
>also used to compose corresponding notification message.
>
>Provide function ethnl_std_notify() to be used as notification handler in
>ethnl_notify_handlers table.
>
>Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
>---
> net/ethtool/netlink.c | 89 +++++++++++++++++++++++++++++++++++++++++++
> net/ethtool/netlink.h |  3 +-
> 2 files changed, 91 insertions(+), 1 deletion(-)
>
>diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
>index 47b6aefa0bf9..dc52d912e0dd 100644
>--- a/net/ethtool/netlink.c
>+++ b/net/ethtool/netlink.c
>@@ -7,6 +7,7 @@
> static struct genl_family ethtool_genl_family;
> 
> static bool ethnl_ok __read_mostly;
>+static u32 ethnl_bcast_seq;
> 
> #define __LINK_MODE_NAME(speed, type, duplex) \
> 	#speed "base" #type "/" #duplex
>@@ -257,6 +258,18 @@ struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
> 	return NULL;
> }
> 
>+static void *ethnl_bcastmsg_put(struct sk_buff *skb, u8 cmd)
>+{
>+	return genlmsg_put(skb, 0, ++ethnl_bcast_seq, &ethtool_genl_family, 0,
>+			   cmd);
>+}
>+
>+static int ethnl_multicast(struct sk_buff *skb, struct net_device *dev)
>+{
>+	return genlmsg_multicast_netns(&ethtool_genl_family, dev_net(dev), skb,
>+				       0, ETHNL_MCGRP_MONITOR, GFP_KERNEL);
>+}

No need for these 2 helpers. Just put the code directly into
ethnl_std_notify() and make the code easier to read.


>+
> /* GET request helpers */
> 
> /**
>@@ -588,6 +601,82 @@ static int ethnl_get_done(struct netlink_callback *cb)
> 	return 0;
> }
> 
>+static const struct get_request_ops *ethnl_std_notify_to_ops(unsigned int cmd)
>+{
>+	WARN_ONCE(1, "unexpected notification type %u\n", cmd);
>+	return NULL;
>+}

Why this isn't a table similar to get_requests ?


>+
>+/* generic notification handler */
>+static void ethnl_std_notify(struct net_device *dev, unsigned int cmd,

Better "common" comparing to "standard", I believe.


>+			     const void *data)
>+{
>+	struct ethnl_reply_data *reply_data;
>+	const struct get_request_ops *ops;
>+	struct ethnl_req_info *req_info;
>+	struct sk_buff *skb;
>+	void *reply_payload;
>+	int reply_len;
>+	int ret;
>+
>+	ops = ethnl_std_notify_to_ops(cmd);
>+	if (!ops)
>+		return;
>+	req_info = kzalloc(ops->req_info_size, GFP_KERNEL);
>+	if (!req_info)
>+		return;
>+	reply_data = kmalloc(ops->reply_data_size, GFP_KERNEL);
>+	if (!reply_data) {
>+		kfree(req_info);
>+		return;
>+	}
>+
>+	req_info->dev = dev;
>+	req_info->global_flags |= ETHTOOL_GFLAG_COMPACT_BITSETS;
>+
>+	ethnl_init_reply_data(reply_data, ops, dev);
>+	ret = ops->prepare_data(req_info, reply_data, NULL);
>+	if (ret < 0)
>+		goto err_cleanup;
>+	reply_len = ops->reply_size(req_info, reply_data);
>+	if (ret < 0)
>+		goto err_cleanup;
>+	ret = -ENOMEM;
>+	skb = genlmsg_new(reply_len, GFP_KERNEL);
>+	if (!skb)
>+		goto err_cleanup;
>+	reply_payload = ethnl_bcastmsg_put(skb, cmd);
>+	if (!reply_payload)
>+		goto err_skb;
>+	ret = ethnl_fill_reply_header(skb, dev, ops->hdr_attr);
>+	if (ret < 0)
>+		goto err_msg;
>+	ret = ops->fill_reply(skb, req_info, reply_data);
>+	if (ret < 0)
>+		goto err_msg;
>+	if (ops->cleanup_data)
>+		ops->cleanup_data(reply_data);
>+
>+	genlmsg_end(skb, reply_payload);
>+	kfree(reply_data);
>+	kfree(req_info);
>+	ethnl_multicast(skb, dev);
>+	return;
>+
>+err_msg:
>+	WARN_ONCE(ret == -EMSGSIZE,
>+		  "calculated message payload length (%d) not sufficient\n",
>+		  reply_len);
>+err_skb:
>+	nlmsg_free(skb);
>+err_cleanup:
>+	if (ops->cleanup_data)
>+		ops->cleanup_data(reply_data);
>+	kfree(reply_data);
>+	kfree(req_info);
>+	return;
>+}
>+
> /* notifications */
> 
> typedef void (*ethnl_notify_handler_t)(struct net_device *dev, unsigned int cmd,
>diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
>index a0ae47bebe51..23e82a4dd265 100644
>--- a/net/ethtool/netlink.h
>+++ b/net/ethtool/netlink.h
>@@ -316,7 +316,8 @@ static inline void ethnl_after_ops(struct net_device *dev)
>  * infrastructure. When used, a pointer to an instance of this structure is to
>  * be added to &get_requests array and generic handlers ethnl_get_doit(),
>  * ethnl_get_dumpit(), ethnl_get_start() and ethnl_get_done() used in
>- * @ethnl_genl_ops
>+ * @ethnl_genl_ops; ethnl_std_notify() can be used in @ethnl_notify_handlers
>+ * to send notifications of the corresponding type.
>  */
> struct get_request_ops {
> 	u8			request_cmd;
>-- 
>2.23.0
>
