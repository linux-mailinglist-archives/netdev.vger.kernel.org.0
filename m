Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8978744A1B
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbfFMSAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:00:45 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41241 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbfFMSAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 14:00:45 -0400
Received: by mail-qt1-f196.google.com with SMTP id 33so15446237qtr.8
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 11:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=tIwNNw0MIvdhB1T9U39nTb0nfPhroJFxVNqMIG21pzE=;
        b=vV0nKqzmyW0RtDuWUSVwttrkBEjWgDqYv+Wkpvy3texi45M5Ee+SK/bi27n5mNrHD0
         VeUY1NVDy10pMMlWaymKr0O06Bvk4UenC/hZqCXqC4+Nj+PBBhmFeD3lON4Z3IZXMS9t
         R5/KVzclp9jRJSlBalzUkHP2DrwjmVgHdgVjDqd/AxnP4IuP66C+1FWpJ3nY/QBEoHvL
         3XF3vb1C8lJqlMqWzzlEsuFifhvrbh76ZtvBdAyrRJGmDBOUyP2qciciLkC7AQCG64LF
         bG0/emVOKCJtQIohfWQh3KOvLh+gYmSQ3azF8VT+V34cPe6HK5RvNRCbp/ljpzYxhDiv
         ikeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=tIwNNw0MIvdhB1T9U39nTb0nfPhroJFxVNqMIG21pzE=;
        b=XQZQcWKViv3UK49u7VwSRYp7ydoWmghJfa7FYuF0SNf4VZvvV08mldbBYjlSrCPtNI
         13VftqTWhQ75YaXLXGO/8UNFTu+UD/4UTMzhKua3VeJsj++UbqgXxWZyFYS+vYPkfAI1
         2yG+mljIvC5t14JUpBY+MAVcPjgCCVpek/A4qP2irpA/LL4CaIdMeBRzFCUlYxzfPbIC
         4x2smvfF2bYO00y+STzD9lXbyg7Q4lMPYzEzH174iU0KTwaR5vTtxKJc+dUNMXSFphcj
         9XutHjK/f9QAUz6orpzS4ImiIMvOGQ9i0q9F9Ttpc8hEeegbhRsiNg53aHWOQDknRXCO
         zUKA==
X-Gm-Message-State: APjAAAVbTD5X7rinir1etFTbASdbi7kiZKMizrKIdJtVAH63tJgwqRSb
        FZ20OkNzsW2Vmb369SwA30bIIPckIZkeM/VGRMveJA==
X-Google-Smtp-Source: APXvYqxBCpIQr9HE8UJ6Ig5KPqk1R7Lx+xm9kbt8svSse71v7eB27zC6+ZJVRu7asR2SZmzTgd9kfZSTTys3y1j/J5w=
X-Received: by 2002:ac8:1a59:: with SMTP id q25mr75832939qtk.76.1560448844160;
 Thu, 13 Jun 2019 11:00:44 -0700 (PDT)
MIME-Version: 1.0
From:   Nathan Huckleberry <nhuck@google.com>
Date:   Thu, 13 Jun 2019 11:00:33 -0700
Message-ID: <CAJkfWY4WkeMv3Z+Nh4B0xtErTAi6mVCriURZTjd2Q__gMtaEqA@mail.gmail.com>
Subject: Cleanup of -Wunused-const-variable in drivers/net/wireless/ti/wl18xx/main.c
To:     eliad@wizery.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey all,

I'm looking into cleaning up ignored warnings in the kernel so we can
remove compiler flags to ignore warnings.

There are two unused variables ('wl18xx_iface_ap_cl_limits' and
'wl18xx_iface_ap_go_limits') in drivers/net/wireless/ti/wl18xx/main.c.
These appear to be limits when using p2p devices, yet they are never
used.

Wanted to reach out for the best course of action to fix the warning.

https://github.com/ClangBuiltLinux/linux/issues/530

Thanks,
Nathan Huckleberry
