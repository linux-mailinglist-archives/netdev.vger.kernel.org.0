Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D995A0FA4
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 13:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiHYLzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 07:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbiHYLzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 07:55:10 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B78A2232
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 04:55:08 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id d15so7842984uak.11
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 04:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=E4LlTJqHxlzMnW1QDa9mNKxikdpXDhsp3/1u7EM15MTyvmTYBDXV/CAi/xtMhjb7nz
         uLVz4w5dLi6UjJA5rTIXm+yCOyMKs4vH+KFf2mYKfGgS64/Q+NtDBHDguthc7ZEd5SbS
         JxDKiXKdroQg/eT8TfZPk3K8jph5mXkB4BJcr7ZQevRgBhGxw+GgUeMo8jTcfzszfzdS
         3x/F4owhpJbAWO22L0AfnQHkSotgbVkVY6ltvoCD7KT9c8Rkc28VxrsVfwEGe7+079Or
         IWv2Zgt8ZnDyghppBOND0HNR9aeQqdXBVqWxcPAQWo3eQCQJHG7DufEJzHqwd4sN5ipo
         Gqyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=yeKnvJPh+Lzrz6O5us1rEYMtwTaTV6c/MEKHyZMnqJu/8ZW0TAI8YQQUHleAehL8ep
         Cjgvu9tWyN7geBSt5FRomxxEJg2h+hmDctf7RN4vxnxEbUU9Hl2X4GJvXPKx8USXwvTC
         0IwpF560bmFn7t4YDvMFBbyRKdiMJg0WAYp5o2b9JcwOWIpWUnwhrroy8lsR6XFEblv4
         QkBBpidhID3ReQt+B65XQeE33Oqbg3HHsHxRiIoE6lvQaQQDvZ32iN63h/rKVVWyiKeB
         E+1JDN8AwqusJ5lPKzt3gUg8psy/xeYCKOi2TCut8WBrHacm5+FAP+OlXY8STLcUmdXt
         750A==
X-Gm-Message-State: ACgBeo1PggRAMDdgLWJbN4/FmadZFOtliSvccMhCCpD/2iFbbSCkwP/H
        qsVJnJYGA8jBntXORX82cAg5QhMTrbgp9xUCakk=
X-Google-Smtp-Source: AA6agR6wHM/ohAuLqBLPD/fIJayChLgo85MMa5PxB2EXtO7q0HORaAPegJhJ/D4Vi+kzpt6xPqVs4wNr6z9SZlzbbHQ=
X-Received: by 2002:ab0:4467:0:b0:39f:52ec:46d7 with SMTP id
 m94-20020ab04467000000b0039f52ec46d7mr1171846uam.77.1661428507595; Thu, 25
 Aug 2022 04:55:07 -0700 (PDT)
MIME-Version: 1.0
Sender: mccaindelicia@gmail.com
Received: by 2002:a59:4745:0:b0:2ec:36c5:327c with HTTP; Thu, 25 Aug 2022
 04:55:06 -0700 (PDT)
From:   Mathew Bowles <mathewbowles2021@gmail.com>
Date:   Thu, 25 Aug 2022 11:55:06 +0000
X-Google-Sender-Auth: jKC_XVtldA_rEQlVLe90pJskumE
Message-ID: <CAJ9S-ZCcDuFkWS7vhW+S5RUYXwKShGY6+_h4FM5Ewp-fQFbhEA@mail.gmail.com>
Subject: Hello, I need your assistance in this very matter
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


