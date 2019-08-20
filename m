Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0DA795C3A
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbfHTK0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:26:44 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:44698 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfHTK0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 06:26:43 -0400
Received: by mail-ot1-f42.google.com with SMTP id w4so4532142ote.11
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 03:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appscode-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=jxBXmJ7CwYy0LRaeEt7Tjy2eznGFlhd3UMCqKevVupc=;
        b=cz8h2McViQ3tKF3Gu6Mi97Xg/TSMIXjkmUtIRteOBXC3T7x8tZ4mzTDdjnF7oMsAhb
         CpLI+cQ9IXgfh+1AzyvwdhC5ZcWjtwubbdj4t47h/lRGOV+DlKEZXOuhK8teIrM5qwqO
         yaSSvmuQNJAVIyAz0+9pFWIlqIP92uetoLqatneGvblOTKKiAzlUxWfIeYWGHkysxD39
         vYhP+hreKNKDSLOXkehuC1Nw6D+1ellVcgc8jcuinT6T5nbfwAN+FyNF7l1jAhZiqOS9
         Sovt6bWS7Uv2HwaGvPRR53hfTg0QHD/PaxpGor5Tmz5WoESJ5RreBVNeo9eWtQnjlWpL
         pXHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=jxBXmJ7CwYy0LRaeEt7Tjy2eznGFlhd3UMCqKevVupc=;
        b=cZhmhhdHiRcgKqe+Cj3DOhmsoUAV5lqmvbWKDj8mbrSNFbn59vJG1ZgCyKDHbqM2F2
         4NTKjFSJEU4lXFCHaBBhUZelmYjQ4tDip0IAdmS+RLoLS9ix6IWW2H9LWGsxXjD4usme
         WnbNNI9VW2OzlGeLFQZpiUfYCQH43q7wS0SJpwETUhUgOiEnsb32Vmn7wFMn9Uquv4R4
         ylPHqasc/LsbFbRiN3WMKpL+oOtFrjDSRpwFTnQ8y9ibtsLvX2EKv8V/1Y6zf2SjD+md
         uS8ehPlkL9YYnOp/vPsbir+paexd54XnynVmxFUnda5pw+7BqDwJGyvjOBeNN5vKoFH+
         D4uw==
X-Gm-Message-State: APjAAAXQ+075ZPeMial9XAO9Ky71ueehj2GrQ6iwvw48/9q9Wz/Dl7Py
        6/JIkxOdTxMEyMTIAapQKkTILi75WduyR15JoPYmcikQ8FhNyQ==
X-Google-Smtp-Source: APXvYqy57ry5fyktSOlyOFaK6K8XsfpWgafDC9IOXsrzDoekCuWWTukHMnpI0d9XJE23EzEhpFqPGxZwQxefJlkTt+4=
X-Received: by 2002:a05:6830:16ce:: with SMTP id l14mr20913690otr.169.1566296802243;
 Tue, 20 Aug 2019 03:26:42 -0700 (PDT)
MIME-Version: 1.0
From:   Tahsin Rahman <tahsin@appscode.com>
Date:   Tue, 20 Aug 2019 16:26:31 +0600
Message-ID: <CAMa4Cyh8EPOJUL6URov3Zh7cjo07j_zTfeS32p_ht0=4jRvCQg@mail.gmail.com>
Subject: Capturing syscall arguments: `kprobe`, `kretprobe` or `tracepoint` or
 `raw_tracepoint` type programs
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
I'm new to ebpf. I want to write an ebpf program that can trace the
syscall arguments and return values.
According to my research, I can do this using `kprobe`, `kretprobe` or
`tracepoint` or `raw_tracepoint` type of bpf programs.

- What factors should I consider when choosing one type of program over another?

- Is the main difference among them is performance benefits? I'd be
great help if one can point me to any documentations about the
performance difference among different types of ebpf programs.

- How can I benchmark these programs?

Thanks!
