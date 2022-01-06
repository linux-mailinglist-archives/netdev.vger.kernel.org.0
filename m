Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27ADB486785
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 17:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241052AbiAFQTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 11:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241118AbiAFQTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 11:19:48 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0084C061201
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 08:19:47 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id l4so2164284wmq.3
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 08:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=VFAYdUcoAa/RBUsWThLomBm2E0VJ5Yt60qDK5YTAZfk=;
        b=B4luoDAoCeN/d7ENShuXlkDh9Za/KJX7/+YXZBfAltBXO7E7UAtwD1C9O/V5FIh3rQ
         zBs8wpfwqg/IeC6UgZG6OKtO8cEvjSdkovSaIGzW/tbdPcsNqNvNl1spaxx8r+BKY5O1
         eg+QAM/up9m21Qkn9ZpJY+0hl2sEX7yWQyWoJIr7sresZtZOYBj1N3U82OgbNJ+dZGDn
         U3RBbwZAqqxnb+ngqnDyyQ+XulXGRAoJvde3dFj75Ab04q+K5iIUP86wdEH3zzc+Eidi
         GeXpjwO1NIqAjl1r8Zz/+IujnQawyxuSqe6X48vsP6vxvfT+pIYRZd2/8uFol1HugGG2
         WGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=VFAYdUcoAa/RBUsWThLomBm2E0VJ5Yt60qDK5YTAZfk=;
        b=0it72g2FgJctlD3f6r9pJMskP5Ko353VEtNu/moh79tyl9H5KCemIap9VoYqAu0FdV
         GATDPIn0V3k9bDvGkNl696goVJXzvB1oLk/A9Ik0ozkXDHFJIg2WNC0ELZ1OIt5XxAN1
         zgVA84CWnk3w/wYFMY597na1SXKr42P+EIhtaQyDm4C40wLdvahX79NiA3ezbqmC/r7e
         2Y6UYxUB3JZKuK3q5NwVGc79K/sB1V10QJZK+H1H5ClcaWj8VV/5U2oiZ77u1MtMCSFM
         8b+QfZFKWrURgdjUDPtvp4inSSvCyD4cjh968jXZ0kmsvW9gsgnfcDxxc50TKLzoaYZs
         90TA==
X-Gm-Message-State: AOAM530pQy/XPgahvWPInJ+Hp+VYW2TLXJs9dwMRr1ZUxWwAa3AaLlT/
        jDJki4+bLrLsTvSVlYr1ZrVgVlrTM8xsstnPXNo=
X-Google-Smtp-Source: ABdhPJw7EKJm6pomMVgPYBMEFqZOom6iAghrayxCh1BkXsrNndZ2VXj+hmxzIczhCOmnGixu6N+jFQ==
X-Received: by 2002:a1c:a9c2:: with SMTP id s185mr1698549wme.164.1641485986364;
        Thu, 06 Jan 2022 08:19:46 -0800 (PST)
Received: from [192.168.1.79] ([154.72.124.102])
        by smtp.gmail.com with ESMTPSA id p13sm2690441wrr.37.2022.01.06.08.19.42
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 06 Jan 2022 08:19:46 -0800 (PST)
Message-ID: <61d716a2.1c69fb81.c8d9e.9784@mx.google.com>
From:   Rebecca Lawrence <ilyassoukoanda30@gmail.com>
X-Google-Original-From: Rebecca Lawrence
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Hello
To:     Recipients <Rebecca@vger.kernel.org>
Date:   Thu, 06 Jan 2022 16:19:36 +0000
Reply-To: ribeccalawrence@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear,
My name is Rebecca, I am a United States and a military woman who has never=
 married with no kids yet. I came across your profile, and I personally too=
k interest in being your friend. For confidential matters, please contact m=
e back through my private email ribeccalawrence@gmail.com to enable me to s=
end you my pictures and give you more details about me. I Hope to hear from=
 you soon.
Regards
Rebecca.
