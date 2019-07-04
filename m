Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 891445F4EE
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 10:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfGDItS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 04:49:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35102 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfGDItS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 04:49:18 -0400
Received: by mail-wm1-f67.google.com with SMTP id c6so5205473wml.0
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 01:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Opqt53sCXyUJn1dYGcaUv8QqkV6K1DcB1fwzBj1dwmA=;
        b=gZ4XEZxkgMW8Yw0Bz/cr8Thcx689u4KUu6s2K8mOLx18BKhblzhAwbNMg6C9sclyKb
         7TzAPwuwnThLEoPy8PVWUDUeoZ1rm1Wj7yW+miJ4/NCrsW9kWov49nKyEBwuQCdZVA+2
         RK/h2xqJYlQ76BfFjDn8AvJJ0XwflT3VnnelAmEAwprPBcluKYiw0AHcNc/ZbKgqsf9t
         +addGwqv2rTD/NCVmgG73StmjwHeEJRsyT1kvuwVSNXzcznEjk9lalZgCoHt5btErf24
         Er9Uh7XZDeAnlMR1+zedqy5sUxZcVuAfoAArTDWqA+MiuXKSuRItT2bEUg6RBlsnpR1S
         Z8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Opqt53sCXyUJn1dYGcaUv8QqkV6K1DcB1fwzBj1dwmA=;
        b=tob87r2kE7iCtRr9ujPDBmiCGLqFsH/vc/GG73kFrroT5c5nn1+GFu3dmXVxEwzHGn
         T3gv6XXP8Fku2ud3Gr28Z5TJoWNZciAmgfDZQjpIuIwjfEcMnw3LXq2hSvZXzUorAS7t
         tG+YgRJ7xIc84oyJPDIYbylwj6KB1EEIx2XlIXnSfShXci9e0KzzpgobmOrUkIZLdpvq
         pSCEmXSmwVu0UkWSoCT92qEkFfvBtYjgoqJNFpwP6bMsMbzr6JzddeVvOZZDBlkqIIWm
         j4u6bTLY/6/wkHINVHJbJeFtjYZKNuj/JiM+RCLmC4fIU03p1/0Xog1GxCqHRrddUcU2
         mfkg==
X-Gm-Message-State: APjAAAU/0lwOwgY9jaQl9wsV5MPUDDHqU6uJO1/KYGgSGD4F8TAkduuc
        D7AeNqLxFp5otbJP+Id0dVs=
X-Google-Smtp-Source: APXvYqwtnYbOzxOXk6NyUec2QzT2mnnKsI8JZcQL5lVe4kpI7MU1EYEoR0UTqTUAdblTQOD1rBr/vg==
X-Received: by 2002:a7b:cf27:: with SMTP id m7mr11788619wmg.7.1562230154732;
        Thu, 04 Jul 2019 01:49:14 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id z25sm4811468wmf.38.2019.07.04.01.49.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 01:49:14 -0700 (PDT)
Date:   Thu, 4 Jul 2019 10:49:13 +0200
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
Message-ID: <20190704084913.GA18546@nanopsycho>
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


>+/* The structure holding data for unified processing GET requests consists of
>+ * two parts: request info and reply data. Request info is related to client
>+ * request and for dump request it stays constant through all processing;
>+ * reply data contains data for composing a reply message. When processing
>+ * a dump request, request info is filled only once but reply data is filled
>+ * from scratch for each reply message.
>+ *
>+ * +-----------------+-----------------+------------------+-----------------+
>+ * | common_req_info |  specific info  | ethnl_reply_data |  specific data  |
>+ * +-----------------+-----------------+------------------+-----------------+
>+ * |<---------- request info --------->|<----------- reply data ----------->|
>+ *
>+ * Request info always starts at offset 0 with struct ethnl_req_info which
>+ * holds information from parsing the common header. It may be followed by
>+ * other members for request attributes specific for current message type.
>+ * Reply data starts with struct ethnl_reply_data which may be followed by
>+ * other members holding data needed to compose a message.
>+ */
>+

[...]


>+/**
>+ * struct get_request_ops - unified handling of GET requests
>+ * @request_cmd:      command id for request (GET)
>+ * @reply_cmd:        command id for reply (GET_REPLY)
>+ * @hdr_attr:         attribute type for request header
>+ * @max_attr:         maximum (top level) attribute type
>+ * @data_size:        total length of data structure
>+ * @repdata_offset:   offset of "reply data" part (struct ethnl_reply_data)

For example, this looks quite scarry for me. You have one big chunk of
data (according to the scheme above) specific for cmd with reply starting
at arbitrary offset.



>+ * @request_policy:   netlink policy for message contents
>+ * @header_policy:    (optional) netlink policy for request header
>+ * @default_infomask: default infomask (to use if none specified)
>+ * @all_reqflags:     allowed request specific flags
>+ * @allow_nodev_do:   allow non-dump request with no device identification
>+ * @parse_request:
>+ *	Parse request except common header (struct ethnl_req_info). Common
>+ *	header is already filled on entry, the rest up to @repdata_offset
>+ *	is zero initialized. This callback should only modify type specific
>+ *	request info by parsed attributes from request message.
>+ * @prepare_data:
>+ *	Retrieve and prepare data needed to compose a reply message. Calls to
>+ *	ethtool_ops handlers should be limited to this callback. Common reply
>+ *	data (struct ethnl_reply_data) is filled on entry, type specific part
>+ *	after it is zero initialized. This callback should only modify the
>+ *	type specific part of reply data. Device identification from struct
>+ *	ethnl_reply_data is to be used as for dump requests, it iterates
>+ *	through network devices which common_req_info::dev points to the
>+ *	device from client request.
>+ * @reply_size:
>+ *	Estimate reply message size. Returned value must be sufficient for
>+ *	message payload without common reply header. The callback may returned
>+ *	estimate higher than actual message size if exact calculation would
>+ *	not be worth the saved memory space.
>+ * @fill_reply:
>+ *	Fill reply message payload (except for common header) from reply data.
>+ *	The callback must not generate more payload than previously called
>+ *	->reply_size() estimated.
>+ * @cleanup:
>+ *	Optional cleanup called when reply data is no longer needed. Can be
>+ *	used e.g. to free any additional data structures outside the main
>+ *	structure which were allocated by ->prepare_data(). When processing
>+ *	dump requests, ->cleanup() is called for each message.
>+ *
>+ * Description of variable parts of GET request handling when using the unified
>+ * infrastructure. When used, a pointer to an instance of this structure is to
>+ * be added to &get_requests array and generic handlers ethnl_get_doit(),
>+ * ethnl_get_dumpit(), ethnl_get_start() and ethnl_get_done() used in
>+ * @ethnl_genl_ops
>+ */
>+struct get_request_ops {
>+	u8			request_cmd;
>+	u8			reply_cmd;
>+	u16			hdr_attr;
>+	unsigned int		max_attr;
>+	unsigned int		data_size;
>+	unsigned int		repdata_offset;
>+	const struct nla_policy *request_policy;
>+	const struct nla_policy *header_policy;
>+	u32			default_infomask;
>+	u32			all_reqflags;
>+	bool			allow_nodev_do;
>+
>+	int (*parse_request)(struct ethnl_req_info *req_info,
>+			     struct nlattr **tb,
>+			     struct netlink_ext_ack *extack);
>+	int (*prepare_data)(struct ethnl_req_info *req_info,
>+			    struct genl_info *info);
>+	int (*reply_size)(const struct ethnl_req_info *req_info);
>+	int (*fill_reply)(struct sk_buff *skb,
>+			  const struct ethnl_req_info *req_info);
>+	void (*cleanup)(struct ethnl_req_info *req_info);
>+};
>+
> #endif /* _NET_ETHTOOL_NETLINK_H */
>-- 
>2.22.0
>
