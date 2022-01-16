Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3B248FC4A
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 12:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbiAPLTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 06:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbiAPLTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 06:19:54 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3B2C06173E
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 03:19:54 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id iw1so15169283qvb.1
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 03:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=dlmn2S3EI9CDldIlfu1tPwXSNwshKHAqPvTXHMrQOEE=;
        b=KkADJSCYoB+8GduGbupfZNPK0w6gQ2pJIcXQkt+PvuX/H6jF46p+KqOYe/uJxpFCHW
         RpJ2yOXPk1qpDRQjG2FOBxEVmrBwX+hs8w3BRfAI93O12ANu4eRV7I/cZhZgkBeWNT6H
         aPVQQ7+1gdABhfWLa6rq5EILNDwXcT1HDWaEJtvSWAZdWVIxna1OVb8jDvy4GdJWyOSu
         OiPXwqGIY8oNqH/pTc/caFGHA1KiTgxeNi8zrGUkteg2Dj+DqvUt1kWSQVOLf5SdGq++
         FEgQnJ84LuMzE6SrfWxLGAof3wmug0o9rkeShDMXXDuRTk+23Jv3GJ5WQJ+V0GfIbBwT
         N5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=dlmn2S3EI9CDldIlfu1tPwXSNwshKHAqPvTXHMrQOEE=;
        b=SODINs1BdcZYJ4jRtMaROR9n0irxcxcXKVezDeqQ/L81aeNT0+US0IKFNkdddU5x3c
         CsE1KZaX+mnh1qMR8W2mwZhJ/QWZNymj70P7DOpLipoGq+73XH5axSfc8KHxUu3V9c1z
         2XLcTa1lM2AZe0YRk4bQdqx2HvkU1Y5lWSKWEBFoTFP0untRvEQPWfvnHHqCto0DdlfK
         3BOQS0EMMbagNuRbZx5kQo7ohSIBe5IDtUhqjaasEk6Fa1+4gElcZtfnz8a0t53n+M53
         y2Hc38RizXJh1Bu/ZFzDmdgFsHOM9rRnSUc0+aPv4Fx0fe5Vn3rmZu+b76uF7T0KAQJ3
         UR3A==
X-Gm-Message-State: AOAM533v3akVMzNwQhvKtMjOKlav6WU9xu8Ob3cZcMoyoR1+tWa0vKKc
        xKjlXB5U+aHfQJfLwpQtu5kx18j129fGiFEDSMA=
X-Google-Smtp-Source: ABdhPJzUJl3BhP8bNc5BWD4ycbImkdieuB/uO7nMfqDNGjm71UYCx0dOTOQsNaNm6Lx5A2t54FgrBUD5n+rKCs4coUs=
X-Received: by 2002:a05:6214:da6:: with SMTP id h6mr5745598qvh.91.1642331993710;
 Sun, 16 Jan 2022 03:19:53 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a0c:f5c1:0:0:0:0:0 with HTTP; Sun, 16 Jan 2022 03:19:53
 -0800 (PST)
From:   "ghinahala759@gmail.com" <eliseboutouli@gmail.com>
Date:   Sun, 16 Jan 2022 11:19:53 +0000
Message-ID: <CAA8orfTUjDGyZzEkyiaOeNPOH7XQqJWT9SRX2=FoVfFkQPQJuA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

44GT44KT44Gr44Gh44Gv44CB44GT44KT44Gr44Gh44Gv44CC44GC44Gq44Gf44Go5LiA57eS44Gr
44GE44KJ44KM44Gm44GG44KM44GX44GE44Gn44GZ44CC56eB44Gu5ZCN5YmN44Gv44Ku44OK44O7
44OP44Op44OT44Gn44GZ44CC56eB44Gv44Kk44K544Op44Ko44Or5Zu96Ziy6LuN44Go5Y2U5Yqb
44GX44Gm44GE44KL5b6T6LuN55yL6K235amm44Gn44GZ44CCDQrnp4Hjga7ogbfmpa3jgIHkurrn
qK7jgIHlm73nsY3jgpLmsJfjgavjgZfjgarjgYTjgafjgY/jgaDjgZXjgYTjgILnp4Hjga/jgYLj
garjgZ/jgajoqbHjgZflkIjjgYbjgZ/jgoHjgavpnZ7luLjjgavph43opoHjgarjgZPjgajjgpLm
jIHjgaPjgabjgYTjgb7jgZnjgIINCuWPi+aDheOBqOODkeODvOODiOODiuODvOOCt+ODg+ODl+OB
q+OBpOOBhOOBpuipseOBl+OBpuOCguOCieOBiOOBvuOBmeOBi++8n+engeOBq+apn+S8muOCkuS4
juOBiOOCi+OBk+OBqOOBjOOBp+OBjeOCi+OBi+OBqeOBhuOBi+OCj+OBi+OCiuOBvuOBm+OCk+OA
guacrOW9k+OBq+engeOBqOOBruiJr+WlveOBp+e5geaghOOBl+OBn+OCs+ODn+ODpeODi+OCseOD
vOOCt+ODp+ODs+OCkuOBl+OBn+OBhOOBruOBp+OBguOCjOOBsOOAgeS7peS4i+OBruengeOBruOD
oeODvOODq+OCouODieODrOOCueOAgWdoaW5haGFsYTc1OQ0KQCBnbWFpbC5jb23jgb7jgafjg6Hj
g7zjg6vjgZfjgabjgY/jgaDjgZXjgYTjgIINCg==
