Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972C656201A
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 18:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbiF3QSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 12:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbiF3QSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 12:18:23 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B321EAFD
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 09:18:21 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q9so28065708wrd.8
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 09:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=21qz1Z80+Dw1e1d/lyl4lJ/UQsiXbri/GS0RbMTGIhk=;
        b=A+WqKGCkpN0cSNrTRPihlfzgKU3z6Eoue95gKtPjKXZL4mvaYg+DYf6mKDMp1dzOyp
         jjpmUFmG7Jrtx4TZcjJSq5DiWkDRLdSeROnPyTVs1gMoEYSOyHXAZwTe12YXgqCcBRIL
         3H6kmVDC1UhOui+9U21H+LxfZDx7BJX9N0FMu35JtX4saeVcsfNEiWIJXRAkrQJht3bi
         WsqCkyIPPDhZRj7+zXUWqYF+siphMaNS/a/fzUlu4SiQ8vxNPFgoDizzukvSfeWt+7eo
         sSHJrJq8ji1SNKstW+jUqtyDgUJbO5qPLMrEBYwp/jVII/WLX/+/Ma8iGHXuPiScmsHP
         vV9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=21qz1Z80+Dw1e1d/lyl4lJ/UQsiXbri/GS0RbMTGIhk=;
        b=WaKl7OjXozayenU9hYHzevVd13vpoJLEzXoAoTP1s+ofJN3vWBWjBEtszHEtIM05d6
         BXG3FkJw0geoMt4FwAmxseuJdOAEcGdtQx/YySwW+wKf91G7mtX3zu3gU4iHxYK1CiZH
         m8vCH1hmYgxyy/tDnEk+fv4ZirCScFSjlFuIolSfssStg/R2y4wG2IETEWz96dTSBRWW
         YVPkIgnuoJuiozoNoph2FQ2pDMrdOCXzO8FGcmp/kQ1Vw3dPWtLfO2/59PONq/OQ9zJA
         NJh9r1SiMXO5XkHJcOKtyjs3m1hiSijTTMOPAG/iphd6APwOdLk3FdPxPuWF/oPFKZDa
         0/Jw==
X-Gm-Message-State: AJIora8BGz5wWPpfhmh/XBmuQkCKTVe5OJ/NKZz/265eibikDxnRcmUY
        CxeKphGEMUQwjwCsOacnjeeIZC9MbmO898YN
X-Google-Smtp-Source: AGRyM1v8ICWHrCio7dakae8loHliBLnhntdeEJGyd8aIm/WXYv2mneXcjRRPVTy7N3qj7tnpN9dJtw==
X-Received: by 2002:a05:6000:1011:b0:21d:4212:854a with SMTP id a17-20020a056000101100b0021d4212854amr1192274wrx.179.1656605900374;
        Thu, 30 Jun 2022 09:18:20 -0700 (PDT)
Received: from DESKTOP-DLIJ48C ([39.53.244.205])
        by smtp.gmail.com with ESMTPSA id bd5-20020a05600c1f0500b003a02f957245sm3142891wmb.26.2022.06.30.09.18.19
        for <netdev@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 30 Jun 2022 09:18:20 -0700 (PDT)
Message-ID: <62bdcccc.1c69fb81.c23ab.6f92@mx.google.com>
Date:   Thu, 30 Jun 2022 09:18:20 -0700 (PDT)
X-Google-Original-Date: 30 Jun 2022 12:18:21 -0400
MIME-Version: 1.0
From:   rosario.crosslandestimation@gmail.com
To:     netdev@vger.kernel.org
Subject: Bid Estimate
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=0D=0A=0D=0AWe provide estimation & quantities takeoff service=
s. We are providing 98-100 accuracy in our estimates and take-off=
s. Please tell us if you need any estimating services regarding y=
our projects.=0D=0A=0D=0ASend over the plans and mention the exac=
t scope of work and shortly we will get back with a proposal on w=
hich our charges and turnaround time will be mentioned=0D=0A=0D=0A=
You may ask for sample estimates and take-offs. Thanks.=0D=0A=0D=0A=
Kind Regards=0D=0ARosario Woodcock=0D=0ACrossland Estimating, INC=
=20

