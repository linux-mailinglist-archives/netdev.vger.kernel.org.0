Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43275603BA
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbiF2PBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbiF2PBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:01:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F30324967;
        Wed, 29 Jun 2022 08:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=u75BnaIZv65/D4EtnoVCQK9Jy3Yfc8PqQDHXzj1JaKg=; b=yApMYDtp8LWyJtG39X2au+AsJo
        /cKHe+qyb1wDCP3Apqwuy5zoX3WnUz6vNM7x+YAmmSSaU0wJtCsc288u6ZgUFe4bx5qxHlQpPH2JE
        H+wyMsM6DeIYkdNnYCH33MF+4/mgmbNCxVUVoxRnLinaCo/2E36hEF5IuXtPDkmgNkCSUCr9VatQx
        UCeEH/o+5yzT3m6My/YdO4zmx1mTrjU0Ggg92m5VJkwWVWEM+sXjRKFjGROqbDqR+/oPeoK8IHfFW
        9ttqronmDisFehvosbJWnXpCwekNmlIBjpNolrIPQUses1kHAV5gbWRPGsWYAMNImCo+TjYafpP9Y
        yJYGt/BQ==;
Received: from [2001:4bb8:199:3788:eb09:6317:6452:5395] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6ZBh-00Ccg4-M7; Wed, 29 Jun 2022 15:01:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        rcu@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: remove CONFIG_ANDROID
Date:   Wed, 29 Jun 2022 17:01:01 +0200
Message-Id: <20220629150102.1582425-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

this series removes the CONFIG_ANDROID.  It just guards the Kconfig
option for binder and then changes a bunch of random defaults and
settings, which makes no sense whatsoever and none of those changes
had any good justifcation in their commit logs either.

