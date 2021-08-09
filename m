Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078233E4067
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 08:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhHIGpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 02:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhHIGpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 02:45:54 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30563C0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 23:45:33 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id yk17so27081292ejb.11
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 23:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=zjuQKULORI9R5i6tcWiiTf7fRBA5dqYiPgnVfOlS+wQ=;
        b=upjSgmZxUORvTIoqjFjpbqPJZ5WaP12v+4R8jsvf7ahpTKyhAttByAj6QfppeBVryj
         px450gAMM6g+YbFy9Izoqgug1P570UFskYoTIngJ+bojrO7TxsfbPco6QArJUKPWbZpX
         ITAdTMfEcZDssRA5R1xCpuFsD5WS6Mlm/ZbZ/8ZsiqKabse1SO5H0hD0suSteSVOb+I6
         2UaCqWBtQ6LaEvbWDe2ewVJuc0csP/Hlr/mnDrl6QPmDv2pY39tx+Fu7c6R5sallW9OT
         IaqNaVnLcAJ/B+r5XZY//K+ZG5xVHfog8tLfLQFBPtMQG3SGn/YIviiHku7m9X81Gl8e
         OBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=zjuQKULORI9R5i6tcWiiTf7fRBA5dqYiPgnVfOlS+wQ=;
        b=V6YcvXY2LQeEcHqbOSybtE7UgDQ+ur5jHfvlASeSyWLPT5YDWMYqcY0FbKosHMo/ex
         YSHJPsTXb3574fa0cM8QcJFUrb6rpT0g7ucm0jmnuvxuMoqVUM+T5b8jf0VU2YzGOk/f
         oR49g+WUoMi95u0+pApXUnMApEZY18YAwq1Ce38RKS7vLhkXjqo26kXflDZ3mjrC1sBW
         AaQEgpRFUf+iRX8edP4nwPln1sm4q9cIfN0Z9LCI2SZuikUWfrwCPXPmegbqlBWr7P6j
         Afer6RLuiqADMQVKs7mT461jOs/7epeOUAPZ/l8FpRLmC0awbo8pp9LKXTOkmOugrHKd
         poAg==
X-Gm-Message-State: AOAM530qlOtugDqMqEwvY+Reh7gAY6pPbTL31dEXuyRskN/9OBfKYbtz
        HJs7CHZ0vnkV8jQs6pwpSAGSiV7nEJuLi6zMnF4=
X-Google-Smtp-Source: ABdhPJy9jhS9bgjOQyUht2wG7Mt5yrIdmbumQGzYFELYkQhxqr9PR16CgfcwAp/29DNnhoabkmunpAotCQ4hNb6J19I=
X-Received: by 2002:a17:906:1e42:: with SMTP id i2mr21554532ejj.76.1628491531867;
 Sun, 08 Aug 2021 23:45:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:906:0:0:0:0 with HTTP; Sun, 8 Aug 2021 23:45:31
 -0700 (PDT)
Reply-To: katiehiggins034@gmail.com
From:   katie <salamatouayindo176@gmail.com>
Date:   Mon, 9 Aug 2021 06:45:31 +0000
Message-ID: <CAKO11TxK+-dFN=ukmmOZAwpw+hW8at0BOcL-nhtjGya2Z0dVpg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0gDQpEb2Jyw70gZGXFiCwgbcO0xb5ldGUgbWkgcHJvc8OtbSBuYXDDrXNhxaUuDQo=
