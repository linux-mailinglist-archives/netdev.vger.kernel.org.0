Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41233F2520
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 05:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237930AbhHTDHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 23:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbhHTDHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 23:07:49 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF6FC061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 20:07:12 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id az7so9493884qkb.5
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 20:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=bMipX4kOYecxwmqJggMx1LqomgdcCtUKCXedc6RIeHY=;
        b=biF6jBRr8K3yQYb3ZTK38Bh8A0+qjNiDpYGmCobP3RZq6yVPuSEgG/uBR5uRIJodPR
         Pm3GvDMCPohDyTDTGfsLDCmZrpjb7ICPRu4fPrsYDD4bwqxE9EQnXJRu2omwUX+fjJZp
         6JD556DeLs1T4mZ0YhSOdHOFMc0AnksxtXrnDsCfcdo9VExC5mvHwAv8eJtYPhLsYod6
         McotfSbn5B/hhFZwzhYqVhglQxl8YFN1TNxr/atuFZ9bNhR0Y3uBQTWDMkecHiimFIAz
         iDzzkD6Qbm2R/HZ8Q9qtTrgeUA9CvGjuHbhqO6P/VtxMvqvTNnxvD6FTbdMHcc1K42hh
         ZxDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=bMipX4kOYecxwmqJggMx1LqomgdcCtUKCXedc6RIeHY=;
        b=LtXqp0ZHuB276o9tHGJZZyOGAOKLyDOj+1X0Tfsc4o0lTozwZIHy3C4vLrB8hQKA38
         sVA5S1QRs6B9324dI307vENunLZLZWzKpyzaJVnUn8CDm5Xz2HKDGJBbayqMrUrqpEb/
         YpmhIzDQBT6Tk2NpNmsMZwe0r9NvRuG7fuWuXIdIQ/fMocRj/7q8UBfb7JLvMI0vp8wR
         bB0FF3/4ZXULTvKW3O+4FMFKUZ0XUnk5SY6OG8Lq4WYVg0C/kVaG4kTa2ltPGlYgFEUj
         uOAeqHID3Ah31fPL637+xZdmrmIWYODn3uwFuRQkiHoadscOer+SpYNIGFI/wwENJJ4T
         Os2w==
X-Gm-Message-State: AOAM532VIa2aP/sMg6xD0yn8LI8LqJexTTdKHm0eGdxzD+HlnllaLU17
        v/rAIOgQzX6+JpX4TAMSShZHG+7veJB6wqtPn9A=
X-Google-Smtp-Source: ABdhPJzF6M5dYnOOKD+uCPeK0QKN5aZgaYqAGcPK1ii3mCkbM+IzZakPSPEaLOaWt8mHxVDG6dgxeL/59rU9NLDWh04=
X-Received: by 2002:a37:5ac7:: with SMTP id o190mr6808488qkb.152.1629428831781;
 Thu, 19 Aug 2021 20:07:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6214:8e:0:0:0:0 with HTTP; Thu, 19 Aug 2021 20:07:11
 -0700 (PDT)
Reply-To: cherrykona25@hotmail.com
From:   Cherry Kona <angela.coulibaly1995@gmail.com>
Date:   Thu, 19 Aug 2021 20:07:11 -0700
Message-ID: <CAB7HvL-hN60xppLyTkNp_kYU=+4QpdihrYd18V_JTPob7H3OtA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Did you receive my last message i sent to you?
