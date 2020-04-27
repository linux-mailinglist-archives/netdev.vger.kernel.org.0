Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234031BB18F
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgD0WhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726204AbgD0WhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 18:37:20 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B03C0610D5;
        Mon, 27 Apr 2020 15:37:20 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id g10so15163257lfj.13;
        Mon, 27 Apr 2020 15:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=anbU4ZvHf34hEotYClri4XIToyUZmMKygID6/9blpDE=;
        b=QCM78I1c5dB2HT2t214Q6JABmam8PDKgbSBkUcHWxMqTKUiDVnCh+x33jA+oNcB1W2
         WLpxcLaDooFZpEocNC8kPNltgW1fio3XSCLb2R+Ve6weV2pLK6PlxCLWtGUCQOxmpkTU
         XRKakyVMDTGfKIEa9+94D4aBhPoBGY/jQlSOODl0r6BjJ0UuH+jyOLiyEwM5z8mGvBul
         U6M02KmTXTihw2TfxSKNcAqxra2jyDtvd6D8UEWEVOgyYBBAEEnOjemWmS8ph+dsyFbv
         mjV7WfAzxLLNCWdTjfQwuNl9cgbfpvjC4HLNp7rbZJvlFaPQ1lSa2fghYJq+NEBIAZti
         6YJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=anbU4ZvHf34hEotYClri4XIToyUZmMKygID6/9blpDE=;
        b=LPVvkI3Jib05RXiYLf52btPMcnSJhSTp/tOL70DbZaeZHvTM+LxNeJKmpRpF0BYCkI
         UjF69XGLRsHyOqLMkBNOcx8ZT/6rxBtBxsRbgt8WLBPFqydFmybUgHIrOCGv1NVAxIyZ
         un5g0Hkt3c2tveTTwpnEY/up+cc8gpVtmf2y1N7AVOj+NmxACPDYACeICU35skxE8TlO
         T1MLy/1/Yz2I+iIyHOIYEQbmciDNsUHmvetBEpww5LJvj4Fhe33bIKjzUC/WHCIpS5E/
         LM7pXr/5H1uakekXUP8WfrNrIk8fE5aIpJBfOjHzPjusxUwikFPJUh+lthF4gzT3ZsqP
         ge5w==
X-Gm-Message-State: AGi0PuaaNtLPJ0TCQ8i5vNaC5PnyQtsDd9Rs5sOMOIjwpCyYFkACIxe/
        zKK8LO7IkQhOkn70uh7WNn/GLIhwpBC8OkJ1ynWvsCwY
X-Google-Smtp-Source: APiQypKhyW1sBoYYIor/KNL9tpzzfRnE/W6JA3hXnLSUhJdgTm+5B+ZQEaL5JDb1VGWct58lbl2PRkbxUBF+WTaUpuA=
X-Received: by 2002:ac2:569b:: with SMTP id 27mr17112441lfr.134.1588027036514;
 Mon, 27 Apr 2020 15:37:16 -0700 (PDT)
MIME-Version: 1.0
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 27 Apr 2020 15:37:05 -0700
Message-ID: <CAADnVQ+weKq=-=KB7j=0FfCE0bLanJ_ppn_p-ropdu8zMhWGqQ@mail.gmail.com>
Subject: BPF office hours
To:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

Announcing =E2=80=9CBPF office hours=E2=80=9D every Thursday 9am pacific ti=
me happening at
https://fb.zoom.us/j/91157637485
The three letter password should be obvious.
The meeting will not be longer than 1 hour.

Please fill in agenda in the spreadsheet:
https://docs.google.com/spreadsheets/d/1LfrDXZ9-fdhvPEp_LHkxAMYyxxpwBXjywWa=
0AejEveU/edit?usp=3Dsharing
It will be used for tracking meeting notes.
Each sheet will be frozen after the meeting to keep records.
If there is nothing in there by Wednesday evening please assume that
the meeting is cancelled.
It will be marked such in the spreadsheet. There will be no explicit
invites and cancellation emails.

These meetings are not a substitute for patch discussions at bpf@vger
but rather a way to get discussions unstuck.

Thank you,
Alexei and Daniel.
