Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E8253D164
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347360AbiFCS1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347243AbiFCS1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:27:04 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F385620C;
        Fri,  3 Jun 2022 11:09:28 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id p8so6207298qtx.9;
        Fri, 03 Jun 2022 11:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G1Y6+oEh04DTPN2ctmvO69sEbXMddv84I3sn1hbhDhM=;
        b=ZukLgW/+A0v3D7mOz87mVUO1Vy9UlPPsZe9vrPY59fjh1S/HIE7USnQW356IvDWdwy
         vNJLPecboDUZaoPvDuOHoJTsdZq5TbJfIvSOJ4133i7zCTipIXItehhLdtefW/98kXUs
         9L2vn1CwIUWOF3TUe3KoGevLo+0XxwwqSyKGNgHRrYsC4kgl6rxJ3Uu9GvHVWsFXmIhM
         3z26QgYX0PrWr8WWpDAfzF1R/e7C7mc8DPa+KbToDS2uWmXKJZ/bMLgFrbiwWsmtAaX8
         LuEKYVy9qRfFtJcBO8oabdM9ofjWS1jiui8uqbS8EWlpCXeSbvLQ1Kp6+jiiIBoVyGrg
         wThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G1Y6+oEh04DTPN2ctmvO69sEbXMddv84I3sn1hbhDhM=;
        b=bnZTWYdybnE5qlOalvr+lZUhD3wT9vJOGiDL2z+YSlvX91z3tsJoc2H6JSBhuHS9Do
         U5/UXnyR0eycsexxkFOuB+qOABeADu23erz+dv0Y0uruRz0FO1BvwYzA6JR2jxhK1Skm
         6x8onCrNT7spmpaPcXGHOj2uCdaWvctKLTMW1pDsT/eyFpzzCiQ5AoTXZdJBICoMU9Tu
         lWHUtpD/CD8x0m3ANBPC9JFaIN8zP2F4HwQeR+jmuqdKBQzXw+JebSFKPZuZEeyGRWs7
         mvIMRE5u0qVCmdL1hIHOjGa+Y1lbW+NpkpGy7tdLrtU7MLy9aA5EOoJkNUX1z/6EYr/+
         xOjA==
X-Gm-Message-State: AOAM530wC3YEyuxgUahqPSS2GzpFLc3hbBEnKr8yeTPYu/J//AxQHQ2m
        AKz4eX9nDJk/QkH8sMjV9G30A/SKmyY31YJ/
X-Google-Smtp-Source: ABdhPJzSicPhKvdyl0bWLmcNkMjr+ymSCaHanHmV7eFoOcWzRAHo4YEFjQGJywyDsSFZvX+JSELSUQ==
X-Received: by 2002:a05:622a:64b:b0:304:c896:3473 with SMTP id a11-20020a05622a064b00b00304c8963473mr8615821qtb.457.1654279766746;
        Fri, 03 Jun 2022 11:09:26 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f4-20020a05620a20c400b006a659ce9821sm5187589qka.63.2022.06.03.11.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:09:26 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net 0/3] Documentation: add description for a couple of sctp sysctl options
Date:   Fri,  3 Jun 2022 14:09:22 -0400
Message-Id: <cover.1654279751.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a couple of sysctl options I recently added, but missed adding
documents for them. Especially for net.sctp.intl_enable, it's hard for
users to setup stream interleaving, as it also needs to call some socket
options.

This patchset is to add documents for them.

Xin Long (3):
  Documentation: add description for net.sctp.reconf_enable
  Documentation: add description for net.sctp.intl_enable
  Documentation: add description for net.sctp.ecn_enable

 Documentation/networking/ip-sysctl.rst | 37 ++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

-- 
2.31.1

