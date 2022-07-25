Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEF55800A7
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbiGYOWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbiGYOWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:22:32 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF9312740
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:22:31 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id q16so10505769pgq.6
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=WKFNDFAQil/gfMzq3J7KaiiRZuTdNkHEG08Ff3jZJBQ=;
        b=hPZ2iMdU0HAeFTlcvdzpX4V2uSfnH1pmEROwkBSmqsYRiwIV3WPmaKgppRpQMwAiSi
         Q/RxEOuhIsX4nCLZfNk8CYV/q9ADAQ8fOcqTnt4J7ZAK7VyBJnikbJVMZGlktVefyz0p
         KDZJzNma2VCzAcHxvF6OmCmVmxgtxj5hymH4SxIaQ3rmFBSPh0EzWyvIkXKP7Af0bsnk
         Q7qJzgerCTpZss7T+V6EGEt94azdaxnUskdNSAHXdq0ZmwPSWnQR7m5X58iaIP4JXcCQ
         D+GVJ/XFoHBehPnxfYnhBTluxQdyAmKYkxN7DqehwsroH/kmCTDxY+ogK9Bqjujac17X
         Cufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=WKFNDFAQil/gfMzq3J7KaiiRZuTdNkHEG08Ff3jZJBQ=;
        b=GMSgOxujGN4vWaYhVu8uTsETp/4BUJGXZ+OTi+IeOygP/gOh7A9nj2086PdmUUcel3
         KFhGaDX0LNmjJBjg/6bFQU6+YHaYOX0XfmjHjHQ9swuWjc3Vz9NDSpsbe4JTkPIK6dRH
         Y5cgcTbzOlfWcAdcW7KDPL4r5rJDdEpZd5DHUtZ01m/h1LQvIowdQizSsqcbEqRsM9pG
         rY1CeCtMdNAIlWESyJecHe2cLlAwQogzAeAqNlGRQ2s/v3h/mX+YqrBEMlA9UgwfMJ4k
         AfnKX8/o6XPFLky22mdXxvt+sxfrVDDgZeARJ5a0yW9iNOjiLXcMY+GEZos4woaB1La2
         hWSw==
X-Gm-Message-State: AJIora/Uc1MXquAtIUdWuG9n5FNJ6nprdvdt9lZzm6GknyxK00jV2YW6
        kYVoRAlxT7GAlfrhZUKcdv+Q3972aAP6vjja+dU=
X-Google-Smtp-Source: AGRyM1uOz/VhyP/4Ce8zFbHY+zBCb28AWaKRQEGOVy7yj/NZmPdM4pXWdokGzwYyWIC8ft4Ai636jwBDHH5e1DGvnDg=
X-Received: by 2002:a63:5fc9:0:b0:419:9871:fc8d with SMTP id
 t192-20020a635fc9000000b004199871fc8dmr11072599pgb.422.1658758950373; Mon, 25
 Jul 2022 07:22:30 -0700 (PDT)
MIME-Version: 1.0
Sender: chrisdickson200@gmail.com
Received: by 2002:a05:7022:658f:b0:42:ceb4:ab0 with HTTP; Mon, 25 Jul 2022
 07:22:29 -0700 (PDT)
From:   Chevronoil Corporation <corporationchevronoil@gmail.com>
Date:   Mon, 25 Jul 2022 15:22:29 +0100
X-Google-Sender-Auth: LNwUjvhEl5IeviEnPp_pChAqDHE
Message-ID: <CAHw_d8a0nyQmX7y6LfQT9jGhRVf+aSAoUsh5FHPP-ONfyjKkyg@mail.gmail.com>
Subject: UPDATE ME IF INTERESTED
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BEWARE, Real company doesn't ask for money, Chevron Oil and Gas United
States is employing now free flight ticket, if you are interested
reply with your Resume/CV.

Regards,
Mr Jack McDonald.
Chevron Corporation USA.
