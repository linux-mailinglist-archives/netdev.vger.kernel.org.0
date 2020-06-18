Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3891FEFD8
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 12:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgFRKpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 06:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgFRKpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 06:45:10 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9FDC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 03:45:09 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id b82so4703856wmb.1
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 03:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=H75Eiyw2nv925j6xT5cvJAnS1NIE1U3NHQq8P1i5UYA=;
        b=wnbFoDX45FqNwCnZLf6ZvFdZwnanntuz81RrLy/H01yZ6pSBlDGFagpG4/+hscqAbp
         pT5RLO8mBsJue8aNzxdw4JfOhx7CUiJKkMYQgczPFFBR6JTMSJoXiBoNScQboAcZlLt6
         DkH5+algPVS3FQ7F1lHHHphrMmSyhAwQf7wK5rFoa956/ThJgyKyMire9pD0Mz5cBYFf
         uPRYKPlg32/fjv8A/d9Ry0+psSouMP0On7h92XWorOucJLf38b+X1Lr8lvTpiY5XdNzp
         H2RoUGJumMtbV/l5/AR4Xt5DyougRqzt1y9AMuJm6eE6Jovf5NdYnjthrOKuOdA+ec71
         4Xjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=H75Eiyw2nv925j6xT5cvJAnS1NIE1U3NHQq8P1i5UYA=;
        b=j/yrdkI5SJve+LK/XX9QssL4x/E3vNkJ75pR8PxU90N5QPKrDAk/kW9W1vJUW/O8bj
         QybXmylXMvFFF3r71/B0jq8WCjNiHUHs3sjP+Mp0Fo/IG6vQMmS0F669lRocHFlV9rpB
         ew3QcmAffCS/bIgs1toRfAN0aI9AU09tm9xNhqkbRgUX+plUgTEQwRcAxjJAVusYQySv
         TJ0GtfcltyRnCH1Xc+bcUb62Jiwa+lUCMIL9d5JgXWwpQ+nxRDsQ8RTPerUQ+/LDEoZ4
         71CfbHr+n5dXKGs/prLGgqVsoQbUN/CoK+lhWBbYcc1UbzL1X7YW626U/3eI5Jxjm03/
         fJVw==
X-Gm-Message-State: AOAM53325eDAnhk4Ms+GwB0Vvs3SZ5DfLy40SNasBkhJ3KcnS5eEbM3O
        d4Uv2yaQyAMqeGe87CgfY3UjPQ==
X-Google-Smtp-Source: ABdhPJx4lbAlvfnQ7RX/qjUQ4yzu8QR1PWtwHNCpTFYuL0L+Jmq3oUKg04eehuINGPnuJHqxYV1Efg==
X-Received: by 2002:a1c:a445:: with SMTP id n66mr3088612wme.19.1592477108487;
        Thu, 18 Jun 2020 03:45:08 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id h18sm3032298wru.7.2020.06.18.03.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 03:45:07 -0700 (PDT)
Date:   Thu, 18 Jun 2020 12:45:07 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pablo@netfilter.org,
        vladbu@mellanox.com
Subject: Re: [PATCH net v4 0/4] several fixes for indirect flow_blocks offload
Message-ID: <20200618104505.GA27897@netronome.com>
References: <1592412907-3856-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1592412907-3856-1-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 12:55:03AM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> v2:
> patch2: store the cb_priv of representor to the flow_block_cb->indr.cb_priv
> in the driver. And make the correct check with the statments
> this->indr.cb_priv == cb_priv
> 
> patch4: del the driver list only in the indriect cleanup callbacks
> 
> v3:
> add the cover letter and changlogs.
> 
> v4:
> collapsed 1/4, 2/4, 4/4 in v3 to one fix
> Add the prepare patch 1 and 2
> 
> This series fixes commit 1fac52da5942 ("net: flow_offload: consolidate
> indirect flow_block infrastructure") that revists the flow_block
> infrastructure.
> 
> patch #1 #2：prepare for fix patch #3
> add and use flow_indr_block_cb_alloc/remove function
> 
> patch #3: fix flow_indr_dev_unregister path
> If the representor is removed, then identify the indirect flow_blocks
> that need to be removed by the release callback and the port representor
> structure. To identify the port representor structure, a new 
> indr.cb_priv field needs to be introduced. The flow_block also needs to
> be removed from the driver list from the cleanup path
> 
> 
> patch#4 fix block->nooffloaddevcnt warning dmesg log.
> When a indr device add in offload success. The block->nooffloaddevcnt
> should be 0. After the representor go away. When the dir device go away
> the flow_block UNBIND operation with -EOPNOTSUPP which lead the warning
> demesg log. 
> The block->nooffloaddevcnt should always count for indr block.
> even the indr block offload successful. The representor maybe
> gone away and the ingress qdisc can work in software mode.

Thanks Wenxu,

Pablo's minor comment wrt patch #1 not withstanding
this series is now looking good to me.

With that fixed feel free to add:

Reviewed-by: Simon Horman <simon.horman@netronome.com>

