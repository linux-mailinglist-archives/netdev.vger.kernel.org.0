Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D14EE180AAA
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 22:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgCJVmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 17:42:25 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:38139 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgCJVmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 17:42:25 -0400
Received: by mail-il1-f194.google.com with SMTP id f5so50386ilq.5
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 14:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=4umSr91OjPWmKMiJ9StaeZlbRr0z/eSAbEfWa8ehn4o=;
        b=VDlDGFK/ZnNEWvrNacdBH3EaZ/cIPaGeUiGs3H6F56XCF2iBE78xVIUijdDqU1Nxdk
         XPDTtvsyJZ8oL0Ge3+cOVzoHx2dQ3fHPWY+eR2rvWR2WNjwu/aGOJJvHK6VBB5NMamFo
         TM5DVJoFhdn3teg7iHI4OJh5LpkNXpMAxYf9myPPPvxUSL9xDUOooUpEPGLuk/fng1Zn
         1qUJoBO4js1ZsMHpFu0QPm2QnULZVleQb87zK18CWT2R1gW+xJrd6JSIp/rttAd3U1TH
         9Hwa0ifDHT+ie6uft+eiPPxSVfrPvcn49Jtz52a3rudIS5/tjBQVXb1Hd7/zsMwoz1Db
         OhTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4umSr91OjPWmKMiJ9StaeZlbRr0z/eSAbEfWa8ehn4o=;
        b=r519BDe6HRVO131uFF2+KXDM73bELCTbXCs1sMMw7HsNmreaA2xz0AOTCID+bXtEZN
         CnIpLv07v86e2TxX8/NvFQ1parW/O7JdzMEJ5ME1Gu2/i5amHs+v5HfDinXEiQgljys+
         DTB1DWon19pIpG8qbG7EGZzl/DkOm60PlpHCFxTamEokwXx9ttFIW6DNlYuU3/Xm2ZP8
         3fffjrIgdwiVs3+obWi36aWidjGOe+E/Q7MPmK6lhly5684rXy0hd9d/BE7vlGA7T3Kr
         yP7PfLVtAUqgFkKyfEHOiCBXnrhGytLU+q/SK3MYnLn/M31Ka1oD61SEuoQlza+BRNbZ
         1bug==
X-Gm-Message-State: ANhLgQ359mbQxDUT2+wB7KFn/4ZwQuCRFrWLyu5+ze/JRaghUyp/CTHd
        JFLQYfOw86s8tE49Wo8Z7OlnGCYnezxlAAGPxwBbb5JvWSjAog==
X-Google-Smtp-Source: ADFU+vvYo3u88uqWl8Xi5eGcbRAoGeX9lyTy3h/ksuZUgkO6Mv8nzE76EtRdFEaMxDXlmgxvRk1ScvEaKTeCoSWeCms=
X-Received: by 2002:a92:2c0b:: with SMTP id t11mr107005ile.154.1583876542717;
 Tue, 10 Mar 2020 14:42:22 -0700 (PDT)
MIME-Version: 1.0
From:   Andrej Ras <kermitthekoder@gmail.com>
Date:   Tue, 10 Mar 2020 14:42:11 -0700
Message-ID: <CAHfguVw9unGL-_ETLzRSVCFqHH5_etafbj1MLaMB+FywLpZjTA@mail.gmail.com>
Subject: What does this code do
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While browsing the Linux networking code I came across these two lines
in __ip_append_data() which I do not understand.

                /* Check if the remaining data fits into current packet. */
                copy = mtu - skb->len;
                if (copy < length)
                        copy = maxfraglen - skb->len;
                if (copy <= 0) {

Why not just use maxfraglen.

Perhaps someone can explain why this is needed.

Regards
