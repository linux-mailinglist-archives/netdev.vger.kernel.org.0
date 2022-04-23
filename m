Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12AD150C890
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 11:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbiDWJan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 05:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234416AbiDWJam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 05:30:42 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D10B10783D
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 02:27:46 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id i24so10203157pfa.7
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 02:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=8kcYV1UmgRi7I0Ig2cyWAxX9Diz5dI/hhC7stHqysgg=;
        b=f+V9t/ZcKbt8Uo4Zy6zgQWcnuEpnUZf67dTiENPBivvdNZBoZPbWSUnKs2Z9BtZMVw
         ofUujdhiUwwu3W784SXJosP6nFnuYxrVcUumPUW9HJgvep9bh57/VgRg6fY922xZCfuI
         wBiMC0dnSkeetiyiDBWGOO52tForc+TJ+/W3ZDsCBzni82mOcu3QTLcB0xoU2RDTqaft
         NLcF1NmhrLuuHxtX3rPhFev0mu74dT3wDnJ4MFwoTTaz0YTmOcCQo1ZzfzjB8ZnVU39f
         9pzQf1HLmSE32gobAbt2DA3YjYuOXcIKDYUv4/bJ3dXw5rtuCUO1Fy6pmWR+xm9BEMRQ
         bXWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=8kcYV1UmgRi7I0Ig2cyWAxX9Diz5dI/hhC7stHqysgg=;
        b=i9q8p1OASr5FRHAljSZXiiYAVUFiqVYcjAT4XdurIBQqkrXkDb29tve2rOH3s/6HVs
         04Kpa/hp5rpfiPBrCG7QOP3YIRvNI0Dzztcc/577SxTMVPGNEdN97uTpj5OC2dwleRDc
         4LBogXksBWW8k5NjKmDRWgy+WpxmiuzlddYmKM+lULM+HwNpwu20qSFKO1G3MNoidyCe
         zZbrg9ZY2vQZDcl5xG4EasUkTUA8Rcme1W5NLomcjYLG/8iTu3l+YXS1o4LWRXYE+OKu
         v22etP1vaG5Lg9QOKeNRKrJJ/GMS+/yiT93kOob8fKJhuubB9W+b3LynGTQ2c6+RBE0O
         arUw==
X-Gm-Message-State: AOAM533Hh8uyq0Ka/Dyp77NeTsRyTQpdjEduCjgfNRWTZK5Fk/kfmhwK
        YIlvXSPOpn0wzPm0+qSSA8tfVgnJ1Gpukp8CYJfRNDBa
X-Google-Smtp-Source: ABdhPJyYOxlejOz9me6WXhJiT6+wy9wxYkRblCOBxBtldaLYkzhdgcMfzOX17pbrGkyY3d6tE5L5NWfbWpcfLRZBZTE=
X-Received: by 2002:a65:4848:0:b0:39c:c393:688c with SMTP id
 i8-20020a654848000000b0039cc393688cmr7205617pgs.376.1650706065727; Sat, 23
 Apr 2022 02:27:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7300:6146:b0:59:74db:ac1c with HTTP; Sat, 23 Apr 2022
 02:27:45 -0700 (PDT)
Reply-To: marianadavies68@hotmail.com
From:   Marian Davies <madjidiakakpogbohoun@gmail.com>
Date:   Sat, 23 Apr 2022 09:27:45 +0000
Message-ID: <CACTLq=UJLY=_AzrCx0jJ-QqbEyo8r9vqu9S0tuhHtmMBs2FQJw@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Did you got my first message ?
