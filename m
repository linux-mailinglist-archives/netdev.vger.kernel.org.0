Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83EB0597B3D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 04:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242586AbiHRB5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 21:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241809AbiHRB5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 21:57:44 -0400
Received: from out199-7.us.a.mail.aliyun.com (out199-7.us.a.mail.aliyun.com [47.90.199.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F82A4B3C;
        Wed, 17 Aug 2022 18:57:42 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0VMYQwYj_1660787855;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VMYQwYj_1660787855)
          by smtp.aliyun-inc.com;
          Thu, 18 Aug 2022 09:57:36 +0800
Message-ID: <1660787737.7869372-1-xuanzhuo@linux.alibaba.com>
Subject: Re: upstream kernel crashes
Date:   Thu, 18 Aug 2022 09:55:37 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        James.Bottomley@hansenpartnership.com, andres@anarazel.de,
        axboe@kernel.dk, c@redhat.com, davem@davemloft.net,
        edumazet@google.com, gregkh@linuxfoundation.org,
        jasowang@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@roeck-us.net, martin.petersen@oracle.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org,
        kasan-dev@googlegroups.com, mst@redhat.com
References: <20220815113729-mutt-send-email-mst@kernel.org>
 <20220815164503.jsoezxcm6q4u2b6j@awork3.anarazel.de>
 <20220815124748-mutt-send-email-mst@kernel.org>
 <20220815174617.z4chnftzcbv6frqr@awork3.anarazel.de>
 <20220815161423-mutt-send-email-mst@kernel.org>
 <20220815205330.m54g7vcs77r6owd6@awork3.anarazel.de>
 <20220815170444-mutt-send-email-mst@kernel.org>
 <20220817061359.200970-1-dvyukov@google.com>
 <1660718191.3631961-1-xuanzhuo@linux.alibaba.com>
 <CAHk-=wghjyi5cyDY96m4LtQ_i8Rdgt9Rsmd028XoU6RU=bsy_w@mail.gmail.com>
In-Reply-To: <CAHk-=wghjyi5cyDY96m4LtQ_i8Rdgt9Rsmd028XoU6RU=bsy_w@mail.gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 08:58:20 -0700, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Tue, Aug 16, 2022 at 11:47 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> >
> > +       BUG_ON(num != virtqueue_get_vring_size(vq));
> > +
>
> Please, no more BUG_ON.
>
> Add a WARN_ON_ONCE() and return an  error.

OK, I will post v2 with WARN_ON_ONCE().

Thanks.


>
>            Linus
