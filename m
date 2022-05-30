Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B762F537A94
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 14:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbiE3MXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 08:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiE3MXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 08:23:41 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1A6793B8
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 05:23:40 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id j10so16410531lfe.12
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 05:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=mNQ+U40v4Jk5THQMAQ35qlnMd3rHPzax0ZnEhguyVkE=;
        b=KLiJh55t3b6gHD8DvYvnLRsfUBT9e0IaZgTIfAwiToqTvnfNHdQXNcARLHcLL6mzKN
         KXhWgnN4f73wEfEYUir5P0nERvZZDNNVy6uJKL+qJ80voZ83a4d3An224tfoyEs/1+1J
         yVAXw810hFMCJfduGE+ENTsO0QKszDrbnWskmFuIeHSs9VtwlYbpom0JC1ll24Gidxxu
         e0aOXB1cyN7MuMI9MGPGaKDw3UQURiQ11K5W23Jq2joD8WwDTkOWuRywormOBYyUslpd
         MfokguqfG2r6BCRXK/pSzNMs+B0EX6XX1E6nw9oXX/StMI1+h7EJ+EHhQZCzSFdkiNki
         ywMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=mNQ+U40v4Jk5THQMAQ35qlnMd3rHPzax0ZnEhguyVkE=;
        b=iAM0HIwRgqO8pBpck5HrHfjwInCMtH28yz2EOzq+IGC2rjdHV4bLsCgSIVwi2ZjG0m
         jpSWMUZARSnVXk9IwehgEZYTYzRx7CeLlPARRD833YFAOZkE1IlZhJDp5DVXDRuXjg7y
         SLskyO5/Xckuuy8MbnaVgKK097elhvggw9BHj5J5tRLD7bn8go0POkL/PeOwu43f95dU
         KhdaQSeuc1QxNONumvozCH1JNr8g9kpRdyCIXBa1BQyS3gwCCtQfXfZaDQ5nAYw/plQ9
         1IG0ZFTswoormNDuF9slLR8d6a9GM5dLeADb7lGPvuUcRtNON6UAk2lwsc97flkIyCD6
         Sl0w==
X-Gm-Message-State: AOAM532tygaVGh+/sfTIwO6JKLmDpWHS2LogGEjkan+Bbowr68PpAjU4
        iOe62D2gIVpLV+UMSyPdz+2+uVakBIXOqOQzoiU=
X-Google-Smtp-Source: ABdhPJwEFMrQ5PUVXyFbCjJqQMqNuYJxcQM9WIVQfjl/H1+FHBa8Bh0kC4yM2xTDpFpse1qcZris/eXzVejF/k9esBE=
X-Received: by 2002:ac2:4e88:0:b0:477:c186:6e83 with SMTP id
 o8-20020ac24e88000000b00477c1866e83mr38170270lfr.663.1653913418503; Mon, 30
 May 2022 05:23:38 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6512:c14:0:0:0:0 with HTTP; Mon, 30 May 2022 05:23:37
 -0700 (PDT)
Reply-To: edwinsschultz@gmail.com
From:   Edwin Schultz <vanesabrook@gmail.com>
Date:   Mon, 30 May 2022 13:23:37 +0100
Message-ID: <CAFtSaVsvbic-m3qoCDy2kNPW7wJa5s4jM6y2mYVLA+W+QHVoYQ@mail.gmail.com>
Subject: Greetings!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings! I=E2=80=99m a Research Assistant of my Company and I have a proj=
ect offer.

My regards
Edwin Schultz
