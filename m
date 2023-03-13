Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197E46B6E4F
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 05:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjCMEIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 00:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCMEIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 00:08:14 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892E6126F0;
        Sun, 12 Mar 2023 21:08:05 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id l1so10006529wry.12;
        Sun, 12 Mar 2023 21:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678680484;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RXawRAIx6eV02ZRwEf548kRyk9SYqMQfx4NlySQytTE=;
        b=T2Mu5LLg9zR4w6aWywuDnjoLsVB4yDtMBxPBqdwyxu7Nt2WOi1/kJhHzXtcvqybDGS
         5iDfKFaICH9zfDB5doQqMk0bS0uReZ8kocbni52uHh6vpbFuBSAsHGslHd4LjJdfvGtM
         DAYERWYHbYlgXniKC+RtBXtk/vziyUng21FAAXzzEjPa+9nM4REORWAR/m/K/xCMS8nu
         hZ61EmbfuuENAc0TolbgpAvyCFwp9CNMubIGWRwV/dTmChlHBlk6YQ295ZoQCLImkAGY
         7qQQ8eItjIzLhB0GhGhQnNy5uSEToLu3sbOpARRPhxlGcV1P6HWWnUUl/jbxztILHNeO
         V9xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678680484;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RXawRAIx6eV02ZRwEf548kRyk9SYqMQfx4NlySQytTE=;
        b=H0ueauyW3AnbG1GLry8huYsXWyx0zVLQfpAcJbt2cajiD+SYlf5NGixdAMKXvaiN9V
         U3Jvi5c3EChFyDIJHmVG1mKSWYmzRNlxSsWE50YioSDQAbWWGuNPQgXRP6ag1MOtNpb6
         SORs0KbXIipa9AjZE9tWq0e4JLNnQl/vm/X0lx3wvTnFbdE1zahHNEuyh8fGJ1IqRFt2
         1ijU30sdm5K5y1QRmpOcYdqljTIV7vde+5cA/yE7vs/cNMPf5Q/NavNNMiNrYcrPz2Yj
         4PL+Q0Y/tm2JMR63jY01QCBYAepbw40Uuy/A3KbhEFclPYs7pEMTTy/DCSJI2m1MHIfp
         6Vvw==
X-Gm-Message-State: AO0yUKU9hMRmv5KvW6/hvQhS9pCa2DpT61iBxUxRruS4MqWuV3IggRtH
        RNwpx/45ttjQ9nmWs4qpEgM=
X-Google-Smtp-Source: AK7set9+WsyZG21rsmESra4j4bSnsngTAgejgwTYjtFpDitqwE9s2K61t/ygvGVNn18m0Falc0sVfQ==
X-Received: by 2002:adf:dbc3:0:b0:2ca:e856:5a4 with SMTP id e3-20020adfdbc3000000b002cae85605a4mr6552429wrj.26.1678680483923;
        Sun, 12 Mar 2023 21:08:03 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id x1-20020adff641000000b002c70c99db74sm6639829wrp.86.2023.03.12.21.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 21:08:03 -0700 (PDT)
Date:   Mon, 13 Mar 2023 07:07:58 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Sumitra Sharma <sumitraartsy@gmail.com>
Cc:     outreachy@lists.linux.dev, GR-Linux-NIC-Dev@marvell.com,
        coiby.xu@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        manishc@marvell.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Staging: qlge: Fix indentation in conditional
 statement
Message-ID: <87174bba-201f-42f1-9e36-5c330351201a@kili.mountain>
References: <20230311172540.GA24832@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311172540.GA24832@ubuntu>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 09:25:40AM -0800, Sumitra Sharma wrote:
> Add tabs/spaces in conditional statements in qlge_dbg.c to fix the
> indentation.
> 
> Signed-off-by: Sumitra Sharma <sumitraartsy@gmail.com>
> ---
>  v2: Fix indentation in conditional statement, noted by Dan Carpenter
>  <error27@gmail.com>
>  

This doesn't apply.  You need to start from a fresh git tree.  Please
read my whole earlier email again.

regards,
dan carpenter

