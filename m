Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8D6564FAA
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 10:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbiGDIYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 04:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiGDIYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 04:24:34 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A867645D;
        Mon,  4 Jul 2022 01:24:33 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id r81-20020a1c4454000000b003a0297a61ddso7475148wma.2;
        Mon, 04 Jul 2022 01:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=8VDmb5hD0Rg+qAaKdqnTf53ON+uQ+2FHX0ENAq7deNU=;
        b=fWo2McuN8C7oaV0v0eMTC/yYHyWEPLLZFnaTjKqdeb/DxC+EEXwXEXpiaRMbMQj+uI
         GqRVG+LnXAF3p6w+lCA5MxdIP2iyWGjdBCPHLXz9Jt/lC01E7LWlxFIECzsaOsirIVV0
         OpwrKop2jtO0aKWTPQONxaf8KBvXt2gCK94bSY3XpCbQq5dhgcOcGYPZsywVcpYYjnqw
         qh0tG/PgSlJjbl/hb3jMxQWgOJ2V+CC8Q3CMHf6gTDUZmy+6dsbkdVhOzeSlSARRzMXu
         6VUlykmN2wTbfxIJEQyARfYjWqi9EFnpuMRHyivJa2+6iT4va5ya8zYaNQPmcvAHStW3
         aDgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=8VDmb5hD0Rg+qAaKdqnTf53ON+uQ+2FHX0ENAq7deNU=;
        b=Up8s0/pLJ7ZDuNjHqBX4k52ytuFJG1rNhKbsjxEkxus7k+vhM7uNlce3Ce7wsQajGj
         RP2ITDIiRpY5EE9+LwIEj67KjF4uHRRTlDQeiJxvYE2mPLoh0h1rORGYSOV0+ImKB1Fv
         yWSs3A0CumFwnkNyfuscGGLA7evvGw9pLdmtR5iB3YfHz/Ft/vX88FBBhYPUJOKWvxYD
         pkDT0mssvd60t5F6wBSEpIMGe5YroCzQkv4hd6uJZlA2xkDlDU3P38rT9X+VPB/IQrHl
         84FLOUSnN2nR5cpU+OPPtvimnetW3zq9RQ6HGd2T5MhE95pHSFDfmv4s4JxW59CnGpUY
         X91w==
X-Gm-Message-State: AJIora8vEu3ba1D303GXzwkDw2++92pvgfJjgKfKWy8UA11JYXjr+mi8
        rJHbkUbZGXGvAIawLAvxacQ=
X-Google-Smtp-Source: AGRyM1usenAKTHds6z/KnMEtKnzXnwc6K884+kceVvftvPqe7W/2gnL/AHMdRCQe7Wi06MV8plFueQ==
X-Received: by 2002:a05:600c:1412:b0:3a1:6e8f:f18f with SMTP id g18-20020a05600c141200b003a16e8ff18fmr29153899wmi.9.1656923071856;
        Mon, 04 Jul 2022 01:24:31 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id k23-20020a7bc317000000b003976fbfbf00sm19382923wmj.30.2022.07.04.01.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 01:24:30 -0700 (PDT)
Date:   Mon, 4 Jul 2022 09:24:28 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] eth: remove neterion/vxge
Message-ID: <YsKjvPl3bUXqeGJf@gmail.com>
Mail-Followup-To: Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org
References: <20220701044234.706229-1-kuba@kernel.org>
 <Yr7NpQz6/esZAiZv@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr7NpQz6/esZAiZv@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 12:34:13PM +0200, Jiri Pirko wrote:
> Isn't there some obsoletion scheme globally applied to kernel device
> support? I would expect something like that.

The only thing I've found is that stuff gets marked with DEPRECATED
in Kconfig.
Having an official CONFIG_DEPRECATED option could be a way to
formalise this more, but I'm not sure if that is needed.

Martin
