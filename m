Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B305BB828
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 17:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbfIWPkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 11:40:37 -0400
Received: from mtax.cdmx.gob.mx ([187.141.35.197]:14557 "EHLO mtaw.cdmx.gob.mx"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727236AbfIWPkh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 11:40:37 -0400
X-NAI-Header: Modified by McAfee Email Gateway (4500)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cdmx.gob.mx; s=72359050-3965-11E6-920A-0192F7A2F08E;
        t=1569253015; h=X-Virus-Scanned:Content-Type:
         MIME-Version:Content-Transfer-Encoding:Content-Description:
         Subject:To:From:Date:Reply-To:Message-Id:X-AnalysisOut:
         X-AnalysisOut:X-AnalysisOut:X-AnalysisOut:
         X-AnalysisOut:X-AnalysisOut:X-SAAS-TrackingID:
         X-NAIMIME-Disclaimer:X-NAIMIME-Modified:X-NAI-Spam-Flag:
         X-NAI-Spam-Threshold:X-NAI-Spam-Score:X-NAI-Spam-Rules:
         X-NAI-Spam-Version; bh=YEoI7TbAIVEIEVpVA8
        ocBbi/eOBwvgqX3xU3MZxpOBM=; b=UDFtz11gkoTAXDv3rD3A
        Q49L6BddUv8LJ864zOZR5uBrmehP4y/x6gdlaj1GezIf17ns7F
        Xk71Hfy0CtjRd/OM+/x6LevUMHdA+4q8HnyVWtFmBPLCwf2QKo
        JtICWOILJGPI/70hTqIS+zNAQW9xGCKRgCT2e+u07SvkVZMrub
        4=
Received: from correo.seciti.cdmx.gob.mx (gdf-correo.cdmx.gob.mx [10.250.102.17]) by mtaw.cdmx.gob.mx with smtp
         id 3d88_590e_5ece906b_1875_45a3_b9d0_7fec54ca061d;
        Mon, 23 Sep 2019 10:36:55 -0500
Received: from localhost (localhost [127.0.0.1])
        by gdf-correo.df.gob.mx (Postfix) with ESMTP id A5929E4CA;
        Mon, 23 Sep 2019 08:49:34 -0500 (CDT)
Received: from correo.seciti.cdmx.gob.mx ([127.0.0.1])
        by localhost (gdf-correo.df.gob.mx [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id nzpEZBPzKat1; Mon, 23 Sep 2019 08:49:34 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
        by gdf-correo.df.gob.mx (Postfix) with ESMTP id 5607B96D5;
        Mon, 23 Sep 2019 07:09:42 -0500 (CDT)
X-Virus-Scanned: amavisd-new at gdf-correo.df.gob.mx
Received: from correo.seciti.cdmx.gob.mx ([127.0.0.1])
        by localhost (gdf-correo.df.gob.mx [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id sWcfMvuWhCS7; Mon, 23 Sep 2019 07:09:42 -0500 (CDT)
Received: from [51.89.105.227] (ip227.ip-51-89-105.eu [51.89.105.227])
        by gdf-correo.df.gob.mx (Postfix) with ESMTPSA id E6FCBAD4B;
        Mon, 23 Sep 2019 06:08:37 -0500 (CDT)
Content-Type: text/plain;
  charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Description: Mail message body
Subject: =?utf-8?b?UmU6IOKCrCAyLDAwMCwwMDAtMDAgRVVS?=
To:     Recipients <dir.general.odu@vcarranza.cdmx.gob.mx>
From:   "Herr Richard Wahl" <dir.general.odu@vcarranza.cdmx.gob.mx>
Date:   Mon, 23 Sep 2019 04:08:32 -0700
Reply-To: liezlnatashavanessa@gmail.com
Message-Id: <20190923110838.E6FCBAD4B@gdf-correo.df.gob.mx>
X-AnalysisOut: [v=2.2 cv=TNY1cxta c=1 sm=1 tr=0 p=2OI1PNnC8JhL0FsIPBYA:9 p]
X-AnalysisOut: [=_N-xJts-NSoA:10 p=lGgLjOrbpN2RxnAZ7M7O:22 a=KsSCQl7LcZej7]
X-AnalysisOut: [7FuluUcQw==:117 a=vLITcJQlLBtmuSUEdzrZzA==:17 a=RwXDzVytnx]
X-AnalysisOut: [sA:10 a=IkcTkHD0fZMA:10 a=x7bEGLp0ZPQA:10 a=J70Eh1EUuV4A:1]
X-AnalysisOut: [0 a=vnREMb7VAAAA:8 a=pGLkceISAAAA:8 a=QEXdDO2ut3YA:10 a=RY]
X-AnalysisOut: [i3TiWdedcA:10 a=zjFIccoYYKb6Fu6_iNvC:22]
X-SAAS-TrackingID: 796e88d5.0.93020198.00-2319.156619500.s12p02m016.mxlogic.net
X-NAIMIME-Disclaimer: 1
X-NAIMIME-Modified: 1
X-NAI-Spam-Flag: NO
X-NAI-Spam-Threshold: 3
X-NAI-Spam-Score: -5000
X-NAI-Spam-Rules: 1 Rules triggered
        WHITELISTED=-5000
X-NAI-Spam-Version: 2.3.0.9418 : core <6640> : inlines <7145> : streams
 <1833603> : uri <2909285>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TGllYmVyIEZyZXVuZCwKCkljaCBiaW4gSGVyciBSaWNoYXJkIFdhaGwgZGVyIE1lZ2EtR2V3aW5u
ZXIgdm9uICQgNTMzTSBJbiBNZWdhIE1pbGxpb25zIEphY2twb3Qgc3BlbmRlIGljaCBhbiA1IHp1
ZsOkbGxpZ2UgUGVyc29uZW4sIHdlbm4gU2llIGRpZXNlIEUtTWFpbCBlcmhhbHRlbiwgZGFubiB3
dXJkZSBJaHJlIEUtTWFpbCBuYWNoIGVpbmVtIFNwaW5iYWxsIGF1c2dld8OkaGx0LiBJY2ggaGFi
ZSBkZW4gZ3LDtsOfdGVuIFRlaWwgbWVpbmVzIFZlcm3DtmdlbnMgYXVmIGVpbmUgUmVpaGUgdm9u
IFdvaGx0w6R0aWdrZWl0c29yZ2FuaXNhdGlvbmVuIHVuZCBPcmdhbmlzYXRpb25lbiB2ZXJ0ZWls
dC4gSWNoIGhhYmUgbWljaCBmcmVpd2lsbGlnIGRhenUgZW50c2NoaWVkZW4sIElobmVuIGRlbiBC
ZXRyYWcgdm9uIOKCrCAyLjAwMC4wMDAsMDAgenUgc3BlbmRlbiBlaW5lIGRlciBhdXNnZXfDpGhs
dGVuIDUsIHVtIG1laW5lIEdld2lubmUgenUgw7xiZXJwcsO8ZmVuLCBmaW5kZW4gU2llIGF1ZiBt
ZWluZXIgWW91IFR1YmUgU2VpdGUgdW50ZW4uCgpVSFIgTUlDSCBISUVSOiBodHRwczovL3d3dy55
b3V0dWJlLmNvbS93YXRjaD92PXRuZTAyRXhORHJ3CgpEYXMgaXN0IGRlaW4gU3BlbmRlbmNvZGU6
IFtERjAwNDMwMzQyMDE4XQoKQW50d29ydGVuIFNpZSBtaXQgZGVtIFNwZW5kZW5jb2RlIGF1ZiBk
aWVzZSBFLU1haWw6IGxpZXpsbmF0YXNoYXZhbmVzc2FAZ21haWwuY29tCgpJY2ggaG9mZmUsIFNp
ZSB1bmQgSWhyZSBGYW1pbGllIGdsw7xja2xpY2ggenUgbWFjaGVuLgoKR3LDvMOfZQoKSGVyciBS
aWNoYXJkIFdhaGwKCgpMYSBpbmZvcm1hY2lvbiBjb250ZW5pZGEgZW4gZXN0ZSBjb3JyZW8sIGFz
aSBjb21vIGxhIGNvbnRlbmlkYSBlbiBsb3MgZG9jdW1lbnRvcyBhbmV4b3MsIHB1ZWRlIGNvbnRl
bmVyIGRhdG9zIHBlcnNvbmFsZXMsIHBvciBsbyBxdWUgc3UgZGlmdXNpb24gZXMgcmVzcG9uc2Fi
aWxpZGFkIGRlIHF1aWVuIGxvcyB0cmFuc21pdGUgeSBxdWllbiBsb3MgcmVjaWJlLCBlbiB0w6ly
bWlub3MgZGUgbG8gZGlzcHVlc3RvIHBvciBsYXMgZnJhY2Npb25lcyBJSSB5IFZJSSBkZWwgYXJ0
aWN1bG8gNCwgdWx0aW1vIHBhcnJhZm8gZGVsIGFydGljdWxvIDgsIGFydGljdWxvIDM2IHBhcnJh
Zm8gSUksIDM4IGZyYWNjaW9uIEkgeSBkZW1hcyBhcGxpY2FibGVzIGRlIGxhIExleSBkZSBUcmFu
c3BhcmVuY2lhIHkgQWNjZXNvIGEgbGEgSW5mb3JtYWNpb24gUHVibGljYSBkZWwgRGlzdHJpdG8g
RmVkZXJhbC4NCkxvcyBEYXRvcyBQZXJzb25hbGVzIHNlIGVuY3VlbnRyYW4gcHJvdGVnaWRvcyBw
b3IgbGEgTGV5IGRlIFByb3RlY2Npb24gZGUgRGF0b3MgUGVyc29uYWxlcyBkZWwgRGlzdHJpdG8g
RmVkZXJhbCwgcG9yIGxvIHF1ZSBzdSBkaWZ1c2lvbiBzZSBlbmN1ZW50cmEgdHV0ZWxhZGEgZW4g
c3VzIGFydGljdWxvcyAyLCA1LCAxNiwgMjEsIDQxIHkgZGVtYXMgcmVsYXRpdm9zIHkgYXBsaWNh
YmxlcywgZGViaWVuZG8gc3VqZXRhcnNlIGVuIHN1IGNhc28sIGEgbGFzIGRpc3Bvc2ljaW9uZXMg
cmVsYXRpdmFzIGEgbGEgY3JlYWNpb24sIG1vZGlmaWNhY2lvbiBvIHN1cHJlc2lvbiBkZSBkYXRv
cyBwZXJzb25hbGVzIHByZXZpc3Rvcy4gQXNpbWlzbW8sIGRlYmVyYSBlc3RhcnNlIGEgbG8gc2XD
sWFsYWRvIGVuIGxvcyBudW1lcmFsZXMgMSAsIDMsIDEyLCAxOCwgMTksIDIwLCAyMSwgMjMsIDI0
LCAyOSwgMzUgeSBkZW1hcyBhcGxpY2FibGVzIGRlIGxvcyBMaW5lYW1pZW50b3MgcGFyYSBsYSBQ
cm90ZWNjaW9uIGRlIERhdG9zIFBlcnNvbmFsZXMgZW4gZWwgRGlzdHJpdG8gRmVkZXJhbC4NCkVu
IGVsIHVzbyBkZSBsYXMgdGVjbm9sb2dpYXMgZGUgbGEgaW5mb3JtYWNpb24geSBjb211bmljYWNp
b25lcyBkZWwgR29iaWVybm8gZGVsIERpc3RyaXRvIEZlZGVyYWwsIGRlYmVyYSBvYnNlcnZhcnNl
IHB1bnR1YWxtZW50ZSBsbyBkaXNwdWVzdG8gcG9yIGxhIExleSBHb2JpZXJubyBFbGVjdHJvbmlj
byBkZWwgRGlzdHJpdG8gRmVkZXJhbCwgbGEgbGV5IHBhcmEgaGFjZXIgZGUgbGEgQ2l1ZGFkIGRl
IE1leGljbyB1bmEgQ2l1ZGFkIE1hcyBBYmllcnRhLCBlbCBhcGFydGFkbyAxMCBkZSBsYSBDaXJj
dWxhciBVbm8gdmlnZW50ZSB5IGxhcyBOb3JtYXMgR2VuZXJhbGVzIHF1ZSBkZWJlcmFuIG9ic2Vy
dmFyc2UgZW4gbWF0ZXJpYSBkZSBTZWd1cmlkYWQgZGUgbGEgSW5mb3JtYWNpb24gZW4gbGEgQWRt
aW5pc3RyYWNpb24gUHVibGljYSBkZWwgRGlzdHJpdG8gRmVkZXJhbC4K
