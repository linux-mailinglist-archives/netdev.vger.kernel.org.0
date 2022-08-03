Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B1E5890C5
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiHCQrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 12:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiHCQrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:47:41 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395D04E84D
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 09:47:38 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id c185so13319261iof.7
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 09:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YbVPSgk9dxNNi8gUS55ivBJ2apU2DlAKvQ9x+13Ao+A=;
        b=auax6tZzEVheQ23bG1cZ6XY/1WL0f5OaJ9eeAMosl28oXlaLweRLYDlvypxouhNQXG
         Wc2GtNUHRNkmOACjZIk1NDTTKhjkn5bgkpkGyo+8BUDWlGhZ+sbOmMeNH2to8Jzsd/bB
         R3fsB0dv7rk4pJ7Jd8vgO5ErHi6+yuZrqEsxYlKMn7YbSl0oSqN/MlAR4R16Ha9dWx2W
         zkGQzummxVUg8KxHhIFvF8V1Q/I+8+bbO0shzS5DmU2qqEW0Tuok5h96NIX5dhe3ZFD3
         lh/ppeRjdBj4pbvv8up6UVwS5bLgTjQ14vmqb77Df9aopmOfmWztIHZiEckKDP0VOnYJ
         unwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YbVPSgk9dxNNi8gUS55ivBJ2apU2DlAKvQ9x+13Ao+A=;
        b=CDgZVoyAlW78xF/ygRtHlLxOSiFNj1M/A9sbjKPLjhled+kOqeWfuOX/SOXF6oJVsY
         C1CCWsbKs1Hw0Kg9p03oyv+R8jy7xk8SUA4vUNsMoJlHzgBvzzGWnyk/YhMERlmx6oH6
         fKnzK8F9HfeD9HyeLVBndFXMRNsQq9eqXan3BfGK5l4IXlUAG8dSB8BBeNdpX8Qjggaj
         5/qLs2vl8VKbrTLb80IwaN4yjEM9SJt0cWXF9TIcQO/a94POSkZ8fJ+YNDIXd2qmiTfA
         zeNT3J/WxaH5T9EdL3jwfYSv9udmbhS3SPopVlSM7WH8FSL+s2XtZ4FkpWnIsG745Q1A
         VxWw==
X-Gm-Message-State: AJIora83/FndwLuw+oe+9+eh0z3Ti1y2OzBst2Djj96THGvvChARVnDw
        NQPZC6FHLAslg1OQ0rdUNA0QdQ==
X-Google-Smtp-Source: AGRyM1vgn3W7ondu7uH/VaFozyf9V6PUcOp1NU1GwyIQEUbIOpiNEVxk/8Esk3Wq6VI0JJeUc7RbhA==
X-Received: by 2002:a05:6602:27cc:b0:5f0:876e:126b with SMTP id l12-20020a05660227cc00b005f0876e126bmr9445973ios.129.1659545258157;
        Wed, 03 Aug 2022 09:47:38 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d123-20020a026281000000b00335c432c4b9sm8033347jac.136.2022.08.03.09.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 09:47:37 -0700 (PDT)
Message-ID: <ecca5fac-aa14-0023-e089-26e05ea68d46@kernel.dk>
Date:   Wed, 3 Aug 2022 10:47:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] io_uring support for zerocopy send
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <d5568318-39ea-0c39-c765-852411409b68@kernel.dk>
 <CAHk-=wjh91hcEix55tH7ydTLHbcg3hZ6SaqgeyVscbYz57crfQ@mail.gmail.com>
 <1bbb9374-c503-37c6-45d8-476a8b761d4a@kernel.dk>
 <CAHk-=whxqSBtkvr4JijDBQ-yDrE91rFHt9D9b0jj=OMYL8mEsg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=whxqSBtkvr4JijDBQ-yDrE91rFHt9D9b0jj=OMYL8mEsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/22 10:44 AM, Linus Torvalds wrote:
> On Wed, Aug 3, 2022 at 9:39 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>>      If you look at the numbers Pavel posted, it's
>> definitely firmly in benchmark land, but I do think the goals of
>> breaking even with non zero-copy for realistic payload sizes is the real
>> differentiator here.
> 
> Well, a big part of why I wrote the query email was exactly because I
> haven't seen any numbers, and the pull request didn't have any links
> to any.
> 
> So you say "the numbers Pavel posted" and I say "where?"

Didn't think of that since it's in the git commit link, but I now
realize that it's like 3 series of things in there.

> It would have been good to have had a link in the pull request (and
> thus in the merge message).

Agree, it should've been in there. Here's the one from the series that
got merged:

https://lore.kernel.org/all/cover.1657643355.git.asml.silence@gmail.com/

-- 
Jens Axboe

