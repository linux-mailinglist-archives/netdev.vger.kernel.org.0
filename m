Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368356CF207
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjC2SSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjC2SSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:18:39 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1DE49D5
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:18:38 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id t10so66752218edd.12
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680113917;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=EPiQBd6DmMU1ax7EpltG6ImzQNfb0csSupwpsHrf6rmJlyqE/X3cZNVZ6OZm8K7HwP
         dSbgK8m5d4lE4YDP789LqmgTS9tfP1aIwNg/LvV8UoavwKeqAX/FwxU7eYHxA9tSsJ4L
         QPClrD7LVAD0T1bEjwvK9mCKaVO4ABaq/dK8IJrYZQ9y8QI78DF7OEH2vOEbZ3izykM9
         w7Ht68ZhoZx19MdMdcqse6s7WYZdZ/4miaJoqlT4I0hVG00nN/16Vm9ALUZ6OshY6OpS
         2H5X0n1FdIN2OMPDR/sRW6ccaqRi8PREfIfJvVqFbZ/wdfHc1fv+RCtyPrVREZtsh9QO
         87wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680113917;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=UQ76P0iXlWXdKNAmBUtugRhDwoh1mgtbMo6esr8AdP9Y8xCh5kkdwYx9OXX5qj0UNc
         XMHCRBXUoVuiDn5vWGBPLX1cBUNkqkMMGEB0nIx5A6YyJXPa1IIdFVpZoklTJjeJN5PE
         oiGP+upS1bbM5oDgXxlU15TdsMwDUrbl7j/G7Ds7VeWVXTouwUkAxnVgcnqNuloM3j0u
         alKsgOrbk+s0ZW5/1f+PTPM9QqKZtCVFK7fWYHko/qHNlM9UGC85k81izmbQ4Xi4T7K3
         dQT/HlScDjCFsT7ap3NOu9eXuNhufqUD1r5PjNsgw+ZmpM7lIjC9fI4SeoP1BNWbdAa2
         2MRw==
X-Gm-Message-State: AAQBX9ffquYG5F1fArF+gJHLZ9J5qMBAjZAFFjS6AHB0iIKfUlUJON2P
        3JGezfwpBvJdCTBq6OINy3z/5MFL+H7iAFLBVa8=
X-Google-Smtp-Source: AKy350aU+l3Ov03C0liuSMvgOxEq8iYW8xNwiHoeKUfAXBhPcNaT4A82zNSPb2r51gDOtO8ATwR22JbYumYWghch/9U=
X-Received: by 2002:a17:906:fc1c:b0:8b2:8876:cdd4 with SMTP id
 ov28-20020a170906fc1c00b008b28876cdd4mr10614117ejb.7.1680113916986; Wed, 29
 Mar 2023 11:18:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab4:a1cb:0:b0:204:d0d2:3d8f with HTTP; Wed, 29 Mar 2023
 11:18:36 -0700 (PDT)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <avasmt002@gmail.com>
Date:   Wed, 29 Mar 2023 11:18:36 -0700
Message-ID: <CAGJq2vt2V2uQE8mL0a6xQ54XgJhwP-M9JKodK3v2okNyVeX54Q@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
