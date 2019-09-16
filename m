Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E683B3813
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 12:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbfIPK2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 06:28:13 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51048 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbfIPK2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 06:28:13 -0400
Received: by mail-wm1-f66.google.com with SMTP id 5so3652089wmg.0
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 03:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1qzYi1w8wyFuLri9Ne0tJio3IDHOd1W51/ZEG8qZ3FA=;
        b=Mj/sLNimoS2MVFMjoZkfFD+FdXaTWoOhV/mt9lpqpIVk1WIpFV2GjvGbqt5M4to0d8
         p+ch2KToozsuP24g7Ncyr6UEbCQABQO949lR7OF7VXT5N+Iy6dOfkuiXyjcdHvUrjsnc
         NCl/HSiEnW0vkt+uB9svd0ySC1iy61wKY2iKEdhNYu7U88mInPPc8JNubW6F6HVnjcGW
         W45ZUZllC9Rgg9EFNy8FzlGg3RwW6ez8Mx+cyFZcBA13mfAXn1c0a23yyKasAeR04tom
         KsEL2NoL6mXNNtYAdPWLePB2wA2wsASSd2NZaicd0HtbEP0t99yTkKcTZgza4q23gEq8
         AU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1qzYi1w8wyFuLri9Ne0tJio3IDHOd1W51/ZEG8qZ3FA=;
        b=khc/A4opbsGF2FTNS8iGVqLC3mbmze50NGHIf9k3bxaxpIUyrMEzeo487/WS7JFGzh
         zG8nopeIsWoVsFbZWv+Pdqj9c26G8hrnzMTLDoK+lmEeeZomJtierAxMaM8iVrl2Cv9m
         7Y6YwyRgUQmHvmjVt84VnunBC5WUSGOnBCQyuiHe88UunHNmD1cEPs1eTCuFpRrWUnbC
         Uam/+UbA3BpPSDHTWJ7D29XyH1PkYQRYbKWguAtSGaVh9iJZPfgohArrDYmfHmCeCp+S
         Vqt6L5bW0hynOMAz99N47NRBjqrWx0qA78Lw94KxYseCvpRq9eAm9A9eR9W0fNhHEko9
         2YDA==
X-Gm-Message-State: APjAAAVYcxNwEBI0W1TYXrTDviarGMSsSNPerAlnK0KbVOS9WAxgrw05
        utGx5btes4QzHRw38VsKuVI0oRbJvLE=
X-Google-Smtp-Source: APXvYqwH/AggRaNzkGonbK9RyiJ5Bj96LCeisdW+yyxoxNhWVhHa7o4nhyUZt55cpYk8LaMptNT0Yw==
X-Received: by 2002:a1c:a552:: with SMTP id o79mr13323037wme.91.1568629691506;
        Mon, 16 Sep 2019 03:28:11 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 33sm46979933wra.41.2019.09.16.03.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 03:28:11 -0700 (PDT)
Date:   Mon, 16 Sep 2019 12:28:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     wenxu@ucloud.cn
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: cls_api: Fix nooffloaddevcnt counter in
 indr block call success
Message-ID: <20190916102810.GN2286@nanopsycho.orion>
References: <1568628934-32085-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568628934-32085-1-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please use get_maintainers script to get list of ccs.

Mon, Sep 16, 2019 at 12:15:34PM CEST, wenxu@ucloud.cn wrote:
>From: wenxu <wenxu@ucloud.cn>
>
>When a block bind with a dev which support indr block call(vxlan/gretap
>device). It can bind success but with nooffloaddevcnt++. It will fail
>when replace the hw filter in tc_setup_cb_call with skip_sw mode for
>checkout the nooffloaddevcnt and skip_sw.

I read this paragraph 5 times, I still don't understand :( Could you
please re-phrase?


>
>if (block->nooffloaddevcnt && err_stop)
>	return -EOPNOTSUPP;
>
>So with this patch, if the indr block call success, it will not modify
>the nooffloaddevcnt counter.
>
>Fixes: 7f76fa36754b ("net: sched: register callbacks for indirect tc block binds")
>Signed-off-by: wenxu <wenxu@ucloud.cn>
>---
> net/sched/cls_api.c | 27 +++++++++++++++------------
> 1 file changed, 15 insertions(+), 12 deletions(-)
>
>diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>index efd3cfb..8a1e3a5 100644
>--- a/net/sched/cls_api.c
>+++ b/net/sched/cls_api.c
>@@ -766,10 +766,10 @@ void tc_indr_block_cb_unregister(struct net_device *dev,
> }
> EXPORT_SYMBOL_GPL(tc_indr_block_cb_unregister);
> 
>-static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
>-			       struct tcf_block_ext_info *ei,
>-			       enum flow_block_command command,
>-			       struct netlink_ext_ack *extack)
>+static int tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
>+			      struct tcf_block_ext_info *ei,
>+			      enum flow_block_command command,
>+			      struct netlink_ext_ack *extack)
> {
> 	struct tc_indr_block_cb *indr_block_cb;
> 	struct tc_indr_block_dev *indr_dev;
>@@ -785,7 +785,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
> 
> 	indr_dev = tc_indr_block_dev_lookup(dev);
> 	if (!indr_dev)
>-		return;
>+		return -ENOENT;
> 
> 	indr_dev->block = command == FLOW_BLOCK_BIND ? block : NULL;
> 
>@@ -793,7 +793,10 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
> 		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
> 				  &bo);
> 
>-	tcf_block_setup(block, &bo);
>+	if (list_empty(&bo.cb_list))
>+		return -EOPNOTSUPP;

How is this part related to the rest of the patch?

>+
>+	return tcf_block_setup(block, &bo);
> }
> 
> static bool tcf_block_offload_in_use(struct tcf_block *block)
>@@ -849,14 +852,14 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
> 	if (err)
> 		return err;
> 
>-	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
> 	return 0;
> 
> no_offload_dev_inc:
> 	if (tcf_block_offload_in_use(block))
> 		return -EOPNOTSUPP;
>-	block->nooffloaddevcnt++;
>-	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
>+	err = tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
>+	if (err)
>+		block->nooffloaddevcnt++;
> 	return 0;
> }
> 
>@@ -866,8 +869,6 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
> 	struct net_device *dev = q->dev_queue->dev;
> 	int err;
> 
>-	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
>-
> 	if (!dev->netdev_ops->ndo_setup_tc)
> 		goto no_offload_dev_dec;
> 	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
>@@ -876,7 +877,9 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
> 	return;
> 
> no_offload_dev_dec:
>-	WARN_ON(block->nooffloaddevcnt-- == 0);
>+	err = tc_indr_block_call(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
>+	if (err)
>+		WARN_ON(block->nooffloaddevcnt-- == 0);
> }
> 
> static int
>-- 
>1.8.3.1
>
