Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D031063746F
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiKXIuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiKXIt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:49:58 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BB710AD3A
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:49:58 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id q7so543358wrr.8
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aNkLEJ+SYgzp6+cNZmqHWUO4zkVZ0erAmhdJuwXbR7Q=;
        b=s7qgrhEO4gQD5laLbCwoy58yDJaMBcOVJbRQq6aOXBKGrw8108Gzox0K1awRTas9Tg
         k0+n9ZSNVgOWhYQQ2OMyfN0hAD27j6DymIwza5kuLBqcpEwKL72qZhjW1vI6AYNVAVxU
         7jo+OCW3wEGXY2I6kyRuA6KVRE2q0yGIBDayOldhU644GZ++W2gyqyQQqAFEDN80kUNu
         uH0NVLUkchlbuQWIJ0KkKm4R11jXVqQRwLpbu6oDE7RuM2G5Yk8lGAvaZ5I/+xC3uiHp
         4wwpfogZ04T0gwRsIKOvuCC/sckwrFkls9/ljxL0SEodbLNAmudanlFV5lQOAh0Is9SE
         Y8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aNkLEJ+SYgzp6+cNZmqHWUO4zkVZ0erAmhdJuwXbR7Q=;
        b=3MJliLh9qq7KxOBJmprS7fiHUns1r6XJS+g1oLD9KgnLGqkVy2J1exwT5oY8o0gkx1
         9HUs5zIaHMx5nlSha5MDt/KI1cjcGov/RrAoVHZWGy6LWV9RLEqSOjeUWtwlefYc4q5z
         X2uhxRLTV9m/W8iGeiYXAWji+MqwM/0Y3SKL4xde93IsgfyYnv0bFr5d0sKPM879eddC
         mk6ZCvsA8Sb1x0Qc33S5409r4SO0k5lqWgiGtXKt9IwNZXVQcFDNGGEW/SDhDXXsZx3A
         dxvZTCFcGOt3YcydpCmZBSImkl8H5+o0T8xq6dbEIo+TtDqY/9WWK+mk01hkWZortHyf
         l0iQ==
X-Gm-Message-State: ANoB5pm4nVtVXW5GJhBYeV9ReyjqwJvYkFRqb1ZX+G3N4bdChDxJIE6O
        9nnakB3gIPbo9ZMnVaaOXp5+QA==
X-Google-Smtp-Source: AA0mqf6qNCTiJl5nmA5rqvY9xo+CJdw6Z3VXuYe17fnjXtZYMvNfonQ33/75bvkAf41nNL4X4c1/9A==
X-Received: by 2002:adf:e303:0:b0:22e:3c66:bda1 with SMTP id b3-20020adfe303000000b0022e3c66bda1mr10930902wrj.139.1669279796739;
        Thu, 24 Nov 2022 00:49:56 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id p17-20020a5d48d1000000b00236488f62d6sm723145wrs.79.2022.11.24.00.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 00:49:56 -0800 (PST)
Date:   Thu, 24 Nov 2022 09:49:54 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 4/9] devlink: remove unnecessary parameter
 from chunk_fill function
Message-ID: <Y38wMrLbt3m3EMuH@nanopsycho>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
 <20221123203834.738606-5-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123203834.738606-5-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 23, 2022 at 09:38:29PM CET, jacob.e.keller@intel.com wrote:
>The devlink parameter of the devlink_nl_cmd_region_read_chunk_fill
>function is not used. Remove it, to simplify the function signature.
>
>Once removed, it is also obvious that the devlink parameter is not
>necessary for the devlink_nl_region_read_snapshot_fill either.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
