Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996196CC628
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbjC1PY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbjC1PYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:24:05 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D94B7EF6;
        Tue, 28 Mar 2023 08:22:45 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id i9so12640245wrp.3;
        Tue, 28 Mar 2023 08:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680016921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FDNl5RBHMLOqWw6NNpHq9sFDw47TQVxayru1NFx18IY=;
        b=mFLQ9e5KcA8hUAXW5ZEzfF9jJXp0D+VBXKwq0jMmmdzvQpH504psmfoulM8JoeY6Ge
         OudwnNlFK3iq/qo6aZUgwQWEVxOPqZ3pgQvdLx/2OTaHtEGvUgsP5L7QFMoiO9utp0pB
         osuEGI4IAX/EOCvtdczzIg7uJPXp32Br6LUrGdoY4SyxVBQht694pdhmGreYkc9NWaeP
         M0As08MHthxFbFaCmGpTGfS46yV01ULXr7D5CJVnNl5bufgJFQXL2ZFL0GExuoGef1bm
         d+BBifbUiOLjG70xRSoPC5dwcUVcG2nfh9fzWCO7uFudolQJU+b02azWnWnQZcDwPRPk
         DaWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680016921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FDNl5RBHMLOqWw6NNpHq9sFDw47TQVxayru1NFx18IY=;
        b=XD+OeS+P8+leYq62xchiEPv44c6R5hZeNjI9hzu/TbHihaclEWfIAofss+OhUAf5yu
         EXhMI8pG8Sd5HPghWoHreS0f/k/LKiT9zrzwdnNRSRt62vNa+7g82IwijN9I1mUU+/PE
         XzMqVS1RVmJot+qyG3k5gldAaNvH32bV1uACnlOExEOfny97SI8j0irhJIFvl8yMAAvx
         xR7EPX5ga/7BQ5SyTdGIEDF0i8lqsew1gyIfh3+O0k7lyZMnti3GLHnTcTFeinv33vjR
         wdOqA94jAUSK1iIPRMnCwDaqX7VIaw6DZ6AYMKQ+HHN5noUKLHqjKiSTnWmr0j1vLyT/
         bmMw==
X-Gm-Message-State: AAQBX9eOPlCbxG44il4rEkspvE7OLZP4zSUsrIUhv5OgpdElX3HuEBI0
        rd7DhMBonhZbUpQRF10oqNQ=
X-Google-Smtp-Source: AKy350bkkBd5qI4YqmFNquYinztvkrfiQ/L1Ny+4YwBs4QWSWarqt/3UmA9AWl5tipUX9E/ctj5lAA==
X-Received: by 2002:a5d:640e:0:b0:2ce:a8e2:f89e with SMTP id z14-20020a5d640e000000b002cea8e2f89emr12853668wru.46.1680016920699;
        Tue, 28 Mar 2023 08:22:00 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id e7-20020a5d5307000000b002c5a1bd5280sm27905120wrv.95.2023.03.28.08.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 08:22:00 -0700 (PDT)
Date:   Tue, 28 Mar 2023 18:21:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: net: dsa: mv88e6xxx: Request for stable inclusion
Message-ID: <20230328152158.qximoksxqed3ctqv@skbuf>
References: <CAOMZO5BTAaEV+vzq8v_gtyBSC24BY7hWVBehKa_X9BFZY4aYaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5BTAaEV+vzq8v_gtyBSC24BY7hWVBehKa_X9BFZY4aYaA@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Fabio,

On Tue, Mar 28, 2023 at 11:51:35AM -0300, Fabio Estevam wrote:
> Hi,
> 
> I am running kernel 6.1 on a system with a mv88e6320 and can easily
> trigger a flood of "mv88e6085 30be0000.ethernet-1:00: VTU member
> violation for vid 10, source port 5" messages.
> 
> When this happens, the Ethernet audio that passes through the switch
> causes a loud noise in the speaker.
> 
> Backporting the following commits to 6.1 solves the problem:
> 
> 4bf24ad09bc0 ("net: dsa: mv88e6xxx: read FID when handling ATU violations")
> 8646384d80f3 ("net: dsa: mv88e6xxx: replace ATU violation prints with
> trace points")
> 9e3d9ae52b56 ("net: dsa: mv88e6xxx: replace VTU violation prints with
> trace points")
> 
> Please apply them to 6.1-stable tree.
> 
> Thanks,
> 
> Fabio Estevam

For my information, is there any relationship between the audio samples
that (presumably) get packet drops resulting in noise, and the traffic
getting VTU member violations? In other words, is the audio traffic sent
using VID 10 on switch port 5?

I don't quite understand, since VLAN-filtered traffic should be dropped,
what is the reason why the trace point patches would help. My only
explanation is that the audio traffic passing through the switch *also*
passes through the CPU, and the trace points reduce CPU load caused by
an unrelated (and rogue) traffic stream.

If this isn't the case, and you see VTU violations as part of normal
operation, I would say that's a different problem for which we would
need more details.
