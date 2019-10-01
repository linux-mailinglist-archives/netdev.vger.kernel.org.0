Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99DFFC40DC
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfJATST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 15:18:19 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39203 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfJATST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 15:18:19 -0400
Received: by mail-io1-f68.google.com with SMTP id a1so50984765ioc.6;
        Tue, 01 Oct 2019 12:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Vzgftghe6JyZN+YlGN2qmUWY6zfQ+/JvL7JG+fAIwNc=;
        b=IbKXwfRy+abwhbAfLkxGiB+Btj22rQ+AOyVKhB6OEWbPaxQs8xBDtgJEiChEydHlWG
         /jGayuKYsSYUdkE2ndE0Eu2GLVwqkFirM0c83GwwRqoAl47hoVtiRGKfKrw4ZFA8gTui
         zpFwGu0f9rVz1eXayFRX33aAaFXtUcI36rFW3Z/x3K2JKGBdjUtTO9nJa9RwUrgQKVaM
         H10u89+QCFTfnb2OiXpTeqRbugsFRLbo/LS9VeUp8Q1DdJqu4sUh2OwFFl3s5He+bQVx
         ELgP1TDhZcEIrZiXdfv263t/BNqktY9i2/lgc+JUOkafm0z52WLSN43ODLSgjpKxFUpM
         Snvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Vzgftghe6JyZN+YlGN2qmUWY6zfQ+/JvL7JG+fAIwNc=;
        b=qW3KsSVtNQ2FNFvmKmdQ57CV4UsbAAMWlpr6l4x+61yuP1/i7KIrZB4/wwGnSIHgex
         IN5cm7jvNXPYiavIxzxP18oufsKOEIvT1teP+egU1X870unsX1FsxQ3bMtb8g7uGyNsP
         pTsQUs0dncfFAGUO2Z39QT/cBzPGxdBPoXPQWcsKmDy7ad5HS3F9c9z5Xb6MI3jvmo8X
         SNXJ/JVN5+LCiDZFLkXfhG4279wYHs/TaNPVlvDuBuhA5axiQhO209EjF1Sqi5E+C5sk
         rS+nhBwrU2pmJvmPHD4hU6quH3DEblTuiXqdX+dfjWMhoDlmAtjEMqU+BcvsG4eEYHH2
         54Eg==
X-Gm-Message-State: APjAAAW+z1iVwCPr08zzQ8Kk6eJiuwetJCeV0LN2c+h0EG5t/ug/o5A9
        ZJYNTJh1PkYbOj1Sq70Ecj0=
X-Google-Smtp-Source: APXvYqx9PzIELe8NxwHUhZgVgSBZjdDFMzrlNGR4AC+wuMa1O2OBAs3Pc9JaypZy1EQypLfh2UwFmw==
X-Received: by 2002:a02:48e:: with SMTP id 136mr25917868jab.20.1569957497406;
        Tue, 01 Oct 2019 12:18:17 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a26sm7529341ioe.77.2019.10.01.12.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 12:18:16 -0700 (PDT)
Date:   Tue, 01 Oct 2019 12:18:09 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5d93a6713cf1d_85b2b0fc76de5b424@john-XPS-13-9370.notmuch>
In-Reply-To: <87d0fhvt4e.fsf@toke.dk>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-3-andriin@fb.com>
 <87d0fhvt4e.fsf@toke.dk>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> =

> > +struct bpf_map_def {
> > +	unsigned int type;
> > +	unsigned int key_size;
> > +	unsigned int value_size;
> > +	unsigned int max_entries;
> > +	unsigned int map_flags;
> > +	unsigned int inner_map_idx;
> > +	unsigned int numa_node;
> > +};
> =

> Didn't we agree on no new bpf_map_def ABI in libbpf, and that all
> additions should be BTF-based?
> =

> -Toke
> =


We use libbpf on pre BTF kernels so in this case I think it makes
sense to add these fields. Having inner_map_idx there should allow
us to remove some other things we have sitting around.

.John=
