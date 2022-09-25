Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4DA5E91E6
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 11:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbiIYJfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 05:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiIYJff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 05:35:35 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A622ED60
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 02:35:34 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c198so4006137pfc.13
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 02:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date;
        bh=+MhoeOZMIHsjirJeJEqTXU5erbVpHdCZ1XsmoNksTTs=;
        b=obQPFs1qPKZppUS71ax4LLXws3tVOqItVHoENOXoER5D2a4ESYNSEqOoAqUu0+fEkG
         +PGm1xvs03lpJXh4NVkVG+OYDCpn4JITXZqvhDcrDWirj39axUhu98lTqPX8dS63cyys
         u3s/bOqBTpfzIDGa4fUdaNvYpzKqdsJSxfu30HeCEBy7wyMZUWnXJkqAm/+6uWV7VJwd
         +14+9IH2MKJLl77u/rpQIlrqoJ0J/G9VqKDbVZV5iwRktih3KSAKHWK1+IZzX4j4M1e2
         XB6p3vnyGjwhda9ccI4I4ihrsFp8X0fx9Tc/sV49Qw2cZFfMBjGm9NRKRfCAgMuTKiwK
         WKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=+MhoeOZMIHsjirJeJEqTXU5erbVpHdCZ1XsmoNksTTs=;
        b=H41Baa079e/TPUYMqnLeZdAJfabZ0080Uz4fg0XG6o1cMEdZjBv4eYfWdQhgiKabUi
         2cjkHO02JpqapPtWfLZimh3Uil4+PpL3casFEoX7CbN7wYzKwS1J+4aPliXa4rUcCBfO
         YeY7i8+H5YD0Johu+lRIVJb3oZl4F1uDgG/TAQUfn9gA6QhkFya3OTpfdvVqYMPNHesa
         /JJuBdY5EBVlpacdQxWDAcG7Qnr68wZtejok1vT0ctyCKOh8QmDJGYY4w0/EOiWD1aWG
         lz5csXT9oZC6lfG25FO8FWJWrmfCcC+5niK05N9D+mYAbBjicKCP299LB7gJWJz5OvZG
         wz0A==
X-Gm-Message-State: ACrzQf00vdQ+0Pn6/j0nr6CASrTLlwxirxo/E4/GtB3aWsYVwyEtrHwQ
        GpXwNl4aMhHWUxKzXoOpyXJNwGEpvEQ0FHDdl7g=
X-Google-Smtp-Source: AMsMyM5ajqoUFY2AXhZ3R7EuVQRd8PKC6qPg4ESb+QP3SWuO301M2CgZ7de7G4glfh4Q/BxoDK5e0fN1dr5giQI0lyI=
X-Received: by 2002:a05:6a00:8cc:b0:52c:7ab5:2ce7 with SMTP id
 s12-20020a056a0008cc00b0052c7ab52ce7mr17575258pfu.28.1664098533290; Sun, 25
 Sep 2022 02:35:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7022:6393:b0:45:7594:116d with HTTP; Sun, 25 Sep 2022
 02:35:32 -0700 (PDT)
From:   James Lazare <komawule@gmail.com>
Date:   Sun, 25 Sep 2022 09:35:32 +0000
Message-ID: <CA+s8yS08sUNLM4Yo9w4ai9M5ZntN7xwWjb9MnVg4_8k-48-Wyw@mail.gmail.com>
Subject: James Lazare
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

15nXldedINeY15XXkS7XkNeg15Ag15DXqdeoINeQ16og15TXk9eV15Ai15wg15TXp9eV15PXnSDX
qdec15kg15DXlSDXqdei15zXmdeZINec16nXnNeV15cg15DXldeq15Ug16nXldeRDQo=
