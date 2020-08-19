Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7698B24A8EB
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgHSWML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSWMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:12:10 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE49C061757;
        Wed, 19 Aug 2020 15:12:10 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 128so158556pgd.5;
        Wed, 19 Aug 2020 15:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=jR3JT70rmRNM6vsO8qmX1MbKYQ90OTWT9h+SWIytADw=;
        b=q5UB2sjLxDm0IylzVL6BvBt0cPKA/8nfCCV2ROgK1nfLwssmLIwPIdUU/IHtvC5sIt
         zKPCx7epGg8Sm1KloWuj4fxITyh7/zjuSM31N6gTJYEzc5hD7S88dWJ62hed82iIIuTU
         0uQwe3q4HLFinJAhFp0nkRZFYNiz2kFwq58t6BUQEt93H+6XphYzzPeCRdZEm6IGRRnN
         p46fYmUahLYW0mE72mqoDHLYuThQUiQS9pJcmwONZWwQ9+oPW07CHWIKPA9U8WN3bCua
         c2xDMZrSfcCA2G8qGtxJn8FRkH82LEKJxn3Bwa8fHon55G65iQCAW2pP4FgyvKDJowzX
         LGig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=jR3JT70rmRNM6vsO8qmX1MbKYQ90OTWT9h+SWIytADw=;
        b=rbwsdXLXmGrKVkCAnNzUUFbpK1AzhU2NwQjBcEzBt6SmJWpVd+08bTFJ9+5ttreSCR
         RPPPfVodQksJfdjMkvuUqweIqGFPe0iBTQxPlX4heiCFzMrlHrltq5wmo8tkeORycJlR
         7Q7LTbQb1Yi4mRZmTzIE8VJvCAS6jdf1t8R8Rw5yVhgyvWGVf7voaZrF/FthizqFwhW3
         mgsE6NmsvSKq5ZZfZZ6pS9OTZhOgVnIq3LWHn32MBHvkeaxbshl2j7KxE+Pzb6LN1FsS
         AxN+bkqypB5AbrZXf0MWMyam7jjwy9UmqgPDaVWZfGBHVCdYlyrUa86OeQf/U5R98htM
         +4lA==
X-Gm-Message-State: AOAM532S1J6f6IQI4bIYEjomnsll6pUUinTicAsZlpFOjeMpzEQJqAid
        SFQo0kNDWkJRJD2ggw5uS1ws1cGBGq3aEoQLqeLXY0HG
X-Google-Smtp-Source: ABdhPJxJDl2cDJ5gosHpfhAos2FeQKIohDmzjuLkI1GtQsb9aMG6Ob5gV3nOn7ayiqGrhDlEhUaRACjhQ79SLoAdfE8=
X-Received: by 2002:a63:1116:: with SMTP id g22mr362141pgl.63.1597875129790;
 Wed, 19 Aug 2020 15:12:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200808175251.582781-1-xie.he.0141@gmail.com>
In-Reply-To: <20200808175251.582781-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 19 Aug 2020 15:11:58 -0700
Message-ID: <CAJht_EMQSfU17tpJzyKmi7QcpVYgDuxf-1V+csfsVmVzgDmGcg@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/lapbether: Added needed_tailroom
To:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin Schiller,

Can you help review this patch? Thanks! It is a very simple patch that
adds the "needed_tailroom" setting for this driver.

Thank you!
Xie He
