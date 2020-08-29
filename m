Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4578D256636
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 11:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgH2JMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 05:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgH2JMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 05:12:22 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94939C061236
        for <netdev@vger.kernel.org>; Sat, 29 Aug 2020 02:12:21 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id g128so1426059iof.11
        for <netdev@vger.kernel.org>; Sat, 29 Aug 2020 02:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=/1CkLNoY9DnwtTehT+DXG92DDh+b75c924qNNG5mfDY=;
        b=DF9lSwJ7GSnqnhcLAMo5Dsz7Hp5INjSLk1Jj9QqAdXXOki/pZ7D4S2OakVghtzhEH1
         MEdZk7aLKfAWws1anrKI5hda/cbaXSguXrk6lcTyUAjvIUmQ1I2qyHn8iHmI/Mfi40Io
         AGPIxWqCelINhRH+my4ieuTUp068A4U9eFj6JYMXLrtASF6cM8ds2jtcVw7SkqGHoI2h
         s8TEhltwrDUEi1cxJF6r5Rvc080vZa3FenLRNvke6w2R3zOYrBYCY+693l46IVlYIMn0
         hJKB9FNtC8bxfcwOs6dGgnF7MRvz5xwomqyqqBulfuTWyAIy5gVQVf9jEXWP/Kq0cZgD
         d07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=/1CkLNoY9DnwtTehT+DXG92DDh+b75c924qNNG5mfDY=;
        b=k6bNQeNozHXqU4lKtI+fLoRTDTqEppP1V+/lak6XvW6hJzv9o4w7dLkWzoIS85EFGi
         5XO8k1IyjnhoUK41cR5OCac/do3wDKFq9NWAXpyYvnQ4hZT2BN4ckGJccDYirpsxTPlZ
         n+Y9VL91EeCqQnFx71YdOZUljS6j5hcJ3O9xjNe0Qj77799ZrOfYyqOh2/IePCGbkPl+
         yfQoZjJMEEIgCVtdDfgOEznKIBT/c9q8CbQ4r7uCwPq0aiXdk5S87v5uydCoCIhN437a
         AKusLWlgy3jWrQ/QL3CHCs3aVClyvjV2j4bgnGI2FekckcjsGiiDnLxPg4SQEB5CLLXe
         B11g==
X-Gm-Message-State: AOAM533thwMme2DmvjX83qB1+3TDiodvorxsEFoWLEPHNu5DdAdexgZa
        oWRcXZfi5WxSxISA2ETHz/ZcakuOEkDbRwpDal0346yz05c=
X-Google-Smtp-Source: ABdhPJyLhbFzKcP//r6DBcFxHFAL4oW9PFPJOr39B71RZpXQc4DYchEEjOemPAqAziTD6CdfAvb2uEa7IZsVNm7EXTY=
X-Received: by 2002:a6b:e006:: with SMTP id z6mr2042886iog.118.1598692340556;
 Sat, 29 Aug 2020 02:12:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAE_-sdmpSSNEt5R2B+v1FaSP+SYCk_khW2KieRL_7xVbR=nfHw@mail.gmail.com>
In-Reply-To: <CAE_-sdmpSSNEt5R2B+v1FaSP+SYCk_khW2KieRL_7xVbR=nfHw@mail.gmail.com>
From:   Denis Gubin <denis.gubin@gmail.com>
Date:   Sat, 29 Aug 2020 12:11:44 +0300
Message-ID: <CAE_-sdmrpoq0nMegmS=7Te3bw0p8VXG6cqDOAjx90v_89HPp2A@mail.gmail.com>
Subject: Re: tc filter add with handle 800::10:800
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In-Reply-To: CAE_-sdmpSSNEt5R2B+v1FaSP+SYCk_khW2KieRL_7xVbR=nfHw

Hi there!

I just understand how it works?
And I want to control by myself which hash table number will be set
tc filter replace dev eno5 parent ffff: pref 49100 handle 800:10:800
protocol ip u32 match u8 0 0

and then I'll can delete this filter by command like this
tc filter delete dev eno5 parent ffff: pref 49100 handle 800:10:800 u32

And then create that filter again by command
tc filter replace dev eno5 parent ffff: pref 49100 handle 800:10:800
protocol ip u32 match u8 0 0

Is it possible ?

I pleased for your help?



On Sat, Aug 29, 2020 at 1:15 AM Denis Gubin <denis.gubin@gmail.com> wrote:
>
> Hello, everyone!
>
> How can I add filter rule with full handle option
>
> tc filter replace dev eno5 parent ffff: pref 49100 handle 800:10:800
> protocol ip u32 match u8 0 0
>
> I get error:
> Error: cls_u32: Handle specified hash table address mismatch
>
> Why I get error?
>
> Am I right to article below?
>
> handle 800:10:888 is this:
> 800 - number of hash table
> 10 - number of divisor
> 888 - number of filter rule
>
> I appreciate for your answers. Thanks!
>
> --
> Best regards,
> Denis Gubin



--
Best regards,
Denis Gubin
