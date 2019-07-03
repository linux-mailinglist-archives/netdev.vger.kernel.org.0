Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD345E68A
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfGCOZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:25:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36779 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbfGCOZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 10:25:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id u8so2632878wmm.1
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 07:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WCpt10uw8DLCQZQfrha1g8E3xDCVMpXiGVz3py0tkzQ=;
        b=Ot7tq8AckH4F2GHhKkP9FKJ7Irnag8ZUN00G04CPW7G185BbY2Z/2IfcuyenSJXniE
         u000E5EhCOsOxT8QswW4YWBnvJCB2qqqnPReBouJI+m7kZ0W8hBlg9yr/g0dwthO5mC7
         ZS9OMbasaUGOZxXmuGQTQsZ6WnRmPC4rl5Ejn2SDK/PDsPnVVGdQ08fsHyWwhtQjM5mQ
         DwIkjrBcXS2umXJPFxv1HhBZBrl6OfTaZkQaVRdF+C+cixf1d+tO57tXrs0k0CfX1RW2
         tuIfGP/rDMRCUy1biYfUIwEO93FN76v3FCDSbe95gR5D1o39WpdAjWU/hJFdKM1096AK
         Wv+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WCpt10uw8DLCQZQfrha1g8E3xDCVMpXiGVz3py0tkzQ=;
        b=H2dM2a7/JmrWD4FSo9bYus5Nbt/EgmeT23Y67F3CgeKleYTP+D09dN7UDEkZvV3PCW
         jg/t36cw/bC0zYnozAyVjVW91yzsyZubK31mh1bAaSyjYW9N/y64PsPraRRSg52Wkd8/
         LaQeuqaoqk17TvrqjHgqSLSgESa4jE2aOu4PEiun3HMHnF2oD1jCzALyYr0k6l2jUhiN
         dN+iG2ADg5lKqka1rwGzprfAaeoOjFKUM1PujcnnvfB5x/thmPI3FwnvymCdR/lk4cAp
         jRoWTOlzpCd6k3uxMIvRPZmIftc62iX0fc+1xAfB2Wf1MqV3qAcX8Ks3/IbOEhWdaFwx
         Vecg==
X-Gm-Message-State: APjAAAVk5yK82HXCGCL+l3HOjsb3Z/xJsARnAOwqde+Zdw2NA8d75YSJ
        i46JgO73U9aE6vXL7oN/6LM=
X-Google-Smtp-Source: APXvYqwCqQArUX/etrY67mVYHFYCzco0cQQI3EcbtJuZhNSDY1BLNF70BVGhyFXJWnvv+yN4bfusoA==
X-Received: by 2002:a7b:c84c:: with SMTP id c12mr8117801wml.70.1562163911314;
        Wed, 03 Jul 2019 07:25:11 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id l11sm2522584wrw.97.2019.07.03.07.25.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 07:25:10 -0700 (PDT)
Date:   Wed, 3 Jul 2019 16:25:10 +0200
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
Subject: Re: [PATCH net-next v6 09/15] ethtool: generic handlers for GET
 requests
Message-ID: <20190703142510.GA2250@nanopsycho>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <4faa0ce52dfe02c9cde5a46012b16c9af6764c5e.1562067622.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4faa0ce52dfe02c9cde5a46012b16c9af6764c5e.1562067622.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 02, 2019 at 01:50:24PM CEST, mkubecek@suse.cz wrote:

[...]	
	
>+/* generic ->doit() handler for GET type requests */
>+static int ethnl_get_doit(struct sk_buff *skb, struct genl_info *info)

It is very unfortunate for review to introduce function in a patch and
don't use it. In general, this approach is frowned upon. You should use
whatever you introduce in the same patch. I understand it is sometimes
hard.

IIUC, you have one ethnl_get_doit for all possible commands, and you
have this ops to do cmd-specific tasks. That is quite unusual. Plus if
you consider the complicated datastructures connected with this, 
I'm lost from the beginning :( Any particular reason form this indirection?
I don't think any other generic netlink code does that (correct me if
I'm wrong). The nice thing about generic netlink is the fact that
you have separate handlers per cmd.

I don't think you need these ops and indirections. For the common parts,
just have a set of common helpers, as the other generic netlink users
are doing. The code would be much easier to read and follow then.


>+{
>+	const u8 cmd = info->genlhdr->cmd;
>+	const struct get_request_ops *ops;
>+	struct ethnl_req_info *req_info;
>+	struct sk_buff *rskb;
>+	void *reply_payload;
>+	int reply_len;
>+	int ret;
>+
>+	ops = get_requests[cmd];
>+	if (WARN_ONCE(!ops, "cmd %u has no get_request_ops\n", cmd))
>+		return -EOPNOTSUPP;
>+	req_info = ethnl_alloc_get_data(ops);
>+	if (!req_info)
>+		return -ENOMEM;
>+	ret = ethnl_std_parse(req_info, info->nlhdr, genl_info_net(info), ops,
>+			      info->extack, !ops->allow_nodev_do);
>+	if (ret < 0)
>+		goto err_dev;
>+	req_info->privileged = ethnl_is_privileged(skb);
>+	ethnl_init_reply_data(req_info, ops, req_info->dev);
>+
>+	rtnl_lock();
>+	ret = ops->prepare_data(req_info, info);
>+	if (ret < 0)
>+		goto err_rtnl;
>+	reply_len = ops->reply_size(req_info);
>+	if (ret < 0)
>+		goto err_cleanup;
>+	ret = -ENOMEM;
>+	rskb = ethnl_reply_init(reply_len, req_info->dev, ops->reply_cmd,
>+				ops->hdr_attr, info, &reply_payload);
>+	if (!rskb)
>+		goto err_cleanup;
>+	ret = ops->fill_reply(rskb, req_info);
>+	if (ret < 0)
>+		goto err_msg;
>+	rtnl_unlock();
>+
>+	genlmsg_end(rskb, reply_payload);
>+	if (req_info->dev)
>+		dev_put(req_info->dev);
>+	ethnl_free_get_data(ops, req_info);
>+	return genlmsg_reply(rskb, info);
>+
>+err_msg:
>+	WARN_ONCE(ret == -EMSGSIZE,
>+		  "calculated message payload length (%d) not sufficient\n",
>+		  reply_len);
>+	nlmsg_free(rskb);
>+err_cleanup:
>+	ethnl_free_get_data(ops, req_info);
>+err_rtnl:
>+	rtnl_unlock();
>+err_dev:
>+	if (req_info->dev)
>+		dev_put(req_info->dev);
>+	return ret;
>+}

[...]
