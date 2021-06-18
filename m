Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCA63ACEC3
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 17:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbhFRPZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 11:25:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37459 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235084AbhFRPXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 11:23:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624029703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vAGQzXgV3STY7cvIJ5jrupgb3BAQalRLgqLEfyZB+PM=;
        b=Gbbr1di6RVDsNpwiqAL9l9EorOVPSn3lAJFuOU5H8VKOlFsfGB0hzR/l4WplWx4e5VXPu9
        EF+1LrfRDD7t1DneyjL9+a8l8kYPtHfI4f5rXzHrjtFqdxLKN1jtip61AfPO3/+azHQYdG
        BGcJkOn7jIHXtO1vvhhNVv5IQ+sEZ0o=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-99S-ajjyMviHHsJcjkcIjg-1; Fri, 18 Jun 2021 11:21:42 -0400
X-MC-Unique: 99S-ajjyMviHHsJcjkcIjg-1
Received: by mail-io1-f71.google.com with SMTP id y26-20020a6be51a0000b02904b200a26422so4382319ioc.8
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 08:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vAGQzXgV3STY7cvIJ5jrupgb3BAQalRLgqLEfyZB+PM=;
        b=nyPmoaXfd61zJwIrH7Y9ZrBB+wTI7YRgd2tNhFsH1YHUtVznrVZyeeKD8OF835qunL
         /ymTO0iLB4683SoL4gBCvH5ZpwNVCamw9c2NZiUG4xuEvsYZKZer146bpe4UnKaqI2ue
         q8KNIbQKFkfY4V7A82x9L1paMfg8naLwrdqu3mXLjId/AZIJ2aU+yL3OAhRO5l175DLW
         y5lnL6zWbphLzlr/A4PTB6k8JttCODe89O91pVSDHw2I44cBrQUn1OvhCtcihKb6PF7V
         HLN9yFfp5qAD0LnX7ShfRjAqyrw42nPROYRv7eYKc1FeLkTbfQ/1k9n8O1ZKzGuz4Olt
         SZVA==
X-Gm-Message-State: AOAM531hPqQ0wbrK+ef4npfiKjufvgMPTHpbhl6lAH9Tz2iofegFHG3O
        l1WmIjGhAO0Oo1QI7yug+8bNB3ArnCOaCMOdZq8siA9Wr+dkcfUSi+q4IJ0BMe7Q4ZM+GSEV61A
        Q4XR+tYM0BfhyMPGMgWk+hCrkiFzIq1Kj
X-Received: by 2002:a05:6e02:1d03:: with SMTP id i3mr7786662ila.35.1624029701094;
        Fri, 18 Jun 2021 08:21:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEXzJ03PFOep/JdVpfSAO0WM5vKzBOWXYfamADixmyM5FdPFlKiSzqHjvyyUjlUuz1Q+a4zWJvYP/QvlQyJ4I=
X-Received: by 2002:a05:6e02:1d03:: with SMTP id i3mr7786652ila.35.1624029700940;
 Fri, 18 Jun 2021 08:21:40 -0700 (PDT)
MIME-Version: 1.0
References: <CACT4oueyNoQAVW1FDcS_aus9sUqNvJhj87e_kUEkzz3azm2+pQ@mail.gmail.com>
In-Reply-To: <CACT4oueyNoQAVW1FDcS_aus9sUqNvJhj87e_kUEkzz3azm2+pQ@mail.gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Fri, 18 Jun 2021 17:21:30 +0200
Message-ID: <CACT4oud-R9-5r-xTFArR4AM=CQrUKrs02RygZf5FAOFOW=Ov=g@mail.gmail.com>
Subject: Re: Correct interpretation of VF link-state=auto
To:     netdev@vger.kernel.org
Cc:     Ivan Vecera <ivecera@redhat.com>,
        Edward Harold Cree <ecree@xilinx.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Pablo Cascon <pabloc@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 12:34 PM =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com=
> wrote:
>
> Hi,
>
> Regarding link-state attribute for a VF, 'man ip-link' says:
> state auto|enable|disable - set the virtual link state as seen by the
> specified VF. Setting to auto means a reflection of the PF link state,
> enable lets the VF to communicate with other VFs on this host even if
> the PF link state is down, disable causes the HW to drop any packets
> sent by the VF.
>
> However, I've seen that different interpretations are made about that
> explanation, especially about "auto" configuration. It is not clear if
> it should follow PF "physical link status" or PF "administrative link
> status". With the latter, `ip set PF down` would put the VF down too,
> but with the former you'd have to disconnect the physical port.
>
> Thanks

Hello,

Sorry for bumping, anybody has any idea that could help?
--=20
=C3=8D=C3=B1igo Huguet

