Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796DF58CFC2
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 23:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244115AbiHHVgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 17:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiHHVgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 17:36:31 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327721149;
        Mon,  8 Aug 2022 14:36:30 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id kb8so18968002ejc.4;
        Mon, 08 Aug 2022 14:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5kxQ+ZvU7Zpdt8jIK6Oo1egCZhgfVZ2VF+eNH9pEI50=;
        b=W6VUK7kmcFo6VcZMCFFom2f1+KzlGsBn+XlF6hsFbu0asPSx7ESGeHxj3cOPJsxNVP
         Zk8Tg3jVWO6/ZjlcsNzWywSc4jxzWiWzwjkzLdGPlGY70RcjE0jGiMqoQcufBCH9sKQ6
         +C5XZlZ0U10Pfa7v2dbe2+wmnmu8ACaCjy0/FJV29RnQYmtUn59mgBuxa/9K7SnJH2V7
         mec5k9QY37YXbxfzBUBm5LaIZchOZXJzCIm/huc7spmdSWEUobBVugBbldB91687G3XL
         /ZlRnNy/Or32enGzuMY0bYNa7grvmKbZZxZOBjqL4pL+VaZrsNF2rMIJ+dMGa9SHeqQq
         5mKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5kxQ+ZvU7Zpdt8jIK6Oo1egCZhgfVZ2VF+eNH9pEI50=;
        b=ZJvZTAyfFFAIXXEFr9u+XYoxBM7m1fvpZVUdY0neXax/v4o3c3sP6waqOAWJoVmE6s
         lol02eJA3RePkNQwPJCe9vfW2FtI9/oeT51EsvmBF2yhy/83oO0/xm//WuFnixTT8ShV
         6iWg9Ao7aWiJUv+ZcLQHxKqq7IRBew6KxJaypxe0vJFAdTUlyoMxIARIeOvYaoZ7qoBX
         jMW8hpYnaL/daBZSafPwb7tuidgZHMe9vvx+F5VfRc66qVhmzwGpqIoSbCeamPvTvODE
         jhtzxfZQSDvH8cVivJZfz2SuBZ2Hw3ct2PqhyNo0oUb12HjPyMHu5/dj5BI90WkUzpW/
         9xQQ==
X-Gm-Message-State: ACgBeo1Zl4NvvDzEJsRoG3pQlOl3muSzpVzqmfkHPkLybs037063VBpT
        m6KiTDHZXkUJqxI2sesD9kIFfaHFe3I3DF7VLKqh+BR0RSo=
X-Google-Smtp-Source: AA6agR5cQ8lkIReExQkPh8ZgvnX5iVWfUNoW16lMAJFjq/5VU5h2xh9wo9+sC2nkvUAuYZEvZI6YR5YFlgGqfUeX5Lg=
X-Received: by 2002:a17:906:29d:b0:6f0:18d8:7be0 with SMTP id
 29-20020a170906029d00b006f018d87be0mr14681700ejf.561.1659994588575; Mon, 08
 Aug 2022 14:36:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220805232834.4024091-1-luiz.dentz@gmail.com>
 <20220805174724.12fcb86a@kernel.org> <CABBYNZLPkVHJRtGkfV8eugAgLoSxK+jf_-UwhSoL2n=9J9TFcw@mail.gmail.com>
 <20220808143011.7136f07a@kernel.org>
In-Reply-To: <20220808143011.7136f07a@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 8 Aug 2022 14:36:16 -0700
Message-ID: <CABBYNZKmuUpmUChz+tixFCOE_pUeaJq0Sbqkvjy54zd9H=GB4A@mail.gmail.com>
Subject: Re: pull request: bluetooth 2022-08-05
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, Aug 8, 2022 at 2:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 8 Aug 2022 12:38:25 -0700 Luiz Augusto von Dentz wrote:
> > > Did you end up switching to the no-rebase/pull-back model or are you
> > > still rebasing?
> >
> > Still rebasing, I thought that didn't make any difference as long as
> > the patches apply.
>
> Long term the non-rebasing model is probably better since it'd be great
> for the bluetooth tree to be included in linux-next.

You mean that bluetooth-next would be pulled directly into linux-next
rather than net-next?

> Since you haven't started using that model, tho, would you mind
> repairing the Fixes tags in this PR? :)

Let me fix them.

-- 
Luiz Augusto von Dentz
