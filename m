Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3046D56068D
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiF2QrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbiF2Qql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:46:41 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C92E3E5EB;
        Wed, 29 Jun 2022 09:45:51 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 38CCD68AA6; Wed, 29 Jun 2022 18:45:44 +0200 (CEST)
Date:   Wed, 29 Jun 2022 18:45:43 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
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
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <20220629164543.GA25672@lst.de>
References: <20220629150102.1582425-1-hch@lst.de> <20220629150102.1582425-2-hch@lst.de> <Yrx5Lt7jrk5BiHXx@zx2c4.com> <20220629161020.GA24891@lst.de> <Yrx6EVHtroXeEZGp@zx2c4.com> <20220629161527.GA24978@lst.de> <Yrx8/Fyx15CTi2zq@zx2c4.com> <20220629163007.GA25279@lst.de> <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 06:38:09PM +0200, Jason A. Donenfeld wrote:
> On the technical topic, an Android developer friend following this
> thread just pointed out to me that Android doesn't use PM_AUTOSLEEP and
> just has userspace causing suspend frequently. So by his rough
> estimation your patch actually *will* break Android devices. Zoinks.
> Maybe he's right, maybe he's not -- I don't know -- but you should
> probably look into this if you want this patch to land without breakage.

And it will also "break" anyone else doing frequent suspends from
userspace, as that behavior is still in no way related to
CONFIG_ANDROID.
