Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F6B61948F
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiKDKiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbiKDKiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:38:04 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8D52B24E
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 03:38:02 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id i6-20020a5d88c6000000b006d088a0e518so2713542iol.19
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 03:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xwwbHVqJA6b/WaoXynWZOPz9nibzpmlhsBICyuCZYx0=;
        b=bdZKEcK9FkKG/FlqSHdhQp8l4QNe4vhUaypearkT/5QEwA6Y3sDuODxosoVh9U+rvy
         c6fdQj3ejkzzGhukOk28I34wsSoav05axn9JO+wZe2QLOIIIdvA9Nk1ylIGkdl9WfJSG
         b223PuKOskZLZzSlfC+HVS6C3clTnIP9vkvdP8iD6qrnKDddvNFX/R9JTcESbnXlZ897
         9a/GWljkwF1qDgV0Xhr18GZEYjhFW41Boto5NreFx5T4ERYgW2n/LGl4+VQXz4mAXtfc
         lHkeUo9i/7/R5VkfRuaCuNVJBXJ7ArYeCWRe4BpHrHLivaZpl15B2vvcQ5oTzsKBWvDe
         pMWQ==
X-Gm-Message-State: ACrzQf1ekYRpRiRfViof6fKzXHqzyO6UYL9RLakYgwyJlTGuyrvtbPbF
        0LAldi7APbnvR/Lg24JXZriMwRqcjqxUz2WjgPeCqiO5x7fn
X-Google-Smtp-Source: AMsMyM5tBYbEB/tIc1vyNY36bmsMJqJ4+y57wYe1YbRmlCCFcmHl14cXR1t5a3eyIjn37px1nw/ITPfPHm9L2fdsV/7f2uMV78FJ
MIME-Version: 1.0
X-Received: by 2002:a6b:6010:0:b0:6d6:e9b0:5d2a with SMTP id
 r16-20020a6b6010000000b006d6e9b05d2amr2776731iog.198.1667558282167; Fri, 04
 Nov 2022 03:38:02 -0700 (PDT)
Date:   Fri, 04 Nov 2022 03:38:02 -0700
In-Reply-To: <CAG_fn=WhGa21EVCPNFp6BO3=CMzHFYNfwpXK+S0m6oxPr9xdrg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d0b9b05eca2ab68@google.com>
Subject: Re: [PATCH] ipv6: addrlabel: fix infoleak when sending struct
 ifaddrlblmsg to network
From:   syzbot 
        <syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com>
To:     Alexander Potapenko <glider@google.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, glider@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>
>> This patch ensures that the reserved field is always initialized.
>>
>> Reported-by: syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com
>
> My bad, should be:
>   Reported-by: syzbot+fa5414772d5c445dac3c@syzkaller.appspotmail.com

I see the command but can't find the corresponding bug.
The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
but the HASH does not correspond to any known bug.
Please double check the address.

