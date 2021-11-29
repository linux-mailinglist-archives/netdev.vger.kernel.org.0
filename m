Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C69C462D59
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 08:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbhK3HQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 02:16:24 -0500
Received: from sdc-v-sdnmail2-ext.epnet.com ([140.234.254.213]:53188 "EHLO
        sdc-v-sdnmail2-ext.epnet.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233216AbhK3HQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 02:16:23 -0500
Received: from sdc-epwebmail2 (sdc-v-epwebmail2.epnet.com [10.83.102.231])
        by sdc-v-sdnmail2-ext.epnet.com (8.14.7/8.14.7/EIS8.14) with ESMTP id 1ATJwYmD010009;
        Mon, 29 Nov 2021 14:58:34 -0500
Message-Id: <202111291958.1ATJwYmD010009@sdc-v-sdnmail2-ext.epnet.com>
MIME-Version: 1.0
Sender: ephost@ebsco.com
From:   support@ebsco.com
To:     a.chan@auckland.ac.nz, gianluca.grimalda@ifw-kiel.de,
        rp237@le.ac.uk, tim.skelton@nihr.ac.uk, u003erp237@leicester.ac.uk,
        rp237@leicester.ac.uk, vitor.calegaro@ufsm.br,
        loreta.cannito@unich.it, baiyun@bjmu.edu.cn, jun_xu@bjmu.edu.cn,
        hongkui_deng@pku.edu.cn, lino@uc-biotech.pt,
        d.stavish@sheffield.ac.uk, fsxiao@mail.jlu.edu.cn,
        communications@swissuniversities.ch, cathal.mccauley@mu.ie,
        support@prodigi.uk, sebastian.arcq@mendeley.com,
        talents4sse@cuhk.edu.cn, generalinfo@oipc.ab.ca, info@oipc.bc.ca,
        yumi.yoshizawa@tandf.com.sg, howard.kim@tandf.com.sg,
        hyosoon.kim@tandf.com.sg, andy.chuang@tandf.com.sg,
        jason.lin@tandf.com.sg, samantha.chua@tandf.com.sg,
        theo.chevalier11@gmail.com, ainar-g@yandex.ru, codebugs@yandex.ru,
        contato@clicksistema.com.br, dmthomas.hoffmann@gmx.de,
        kairo@kairo.at, luke@warlow.dev, m.kurz@irregular.at,
        me@rachelandrew.co.uk, steven@sdf.me.uk, jacek@kuzemczak.co.uk,
        carlsen@flairproductions.dk, j.skoczek@createit.com,
        chadreitsma@shaw.ca, julian.reschke@gmx.de, kilian@catsoft.ch,
        teun@be.nl, j.norahntambi@gmail.com, jjmeric@free.fr,
        marcoagpinto@sapo.pt, sander@lepik.eu, bjoern@j3e.de,
        jihui.choi@gmail.com, team@firefox.no, ambs@di.uminho.pt,
        lolkeklololo3@yandex.ru, jose.h.espinosa@gmail.com, info@soblex.de,
        stephanie.evans@phe.gov.uk, ccce@cheminst.ca, cktech@ckgroup.co.uk,
        pharmacontracts@ckagroup.co.uk, nicole.poole@csiro.au,
        aguimard@ckqls.ch, sfarrow@ckgroup.co.uk, math4mat-search@epfl.ch,
        yueling.seow@tandf.com.sg, irjournal@uw.edu.pl,
        editorial@open-research-europe.ec.europa.eu,
        linux-acpi@archiver.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        andrew@lunn.ch, arnd@arndb.de,
        77eed.1635317102.git.yu.c.chen@intel.com,
        9110e.1635317102.git.yu.c.chen@intel.com,
        35715.1635317102.git.yu.c.chen@intel.com,
        47b8f.1635317102.git.yu.c.chen@intel.com,
        7519.4789817107293464743.stgit@warthog.procyon.org.uk,
        7519.6594360917661719152.stgit@warthog.procyon.org.uk,
        519.11215118047756175525.stgit@warthog.procyon.org.uk,
        519.13954182746095781120.stgit@warthog.procyon.org.uk,
        519.14706391695553204156.stgit@warthog.procyon.org.uk,
        7519.8649368675533788865.stgit@warthog.procyon.org.uk,
        519.17630241595380785887.stgit@warthog.procyon.org.uk,
        7519.2951437510049163050.stgit@warthog.procyon.org.uk,
        7519.8303891885033763947.stgit@warthog.procyon.org.uk,
        7519.5910362900676754518.stgit@warthog.procyon.org.uk,
        028190125.391374-1-mmakassikis@freebox.fr,
        jwoithe@physics.adelaide.edu.au, hmh@hmh.eng.br,
        astarikovskiy@suse.de, rjw@sisk.pl, linux-cifs@archiver.kernel.org,
        linux-cifs@vger.kernel.org, mmakassikis@freebox.fr,
        019153937.412534-1-mmakassikis@freebox.fr,
        019083641.116783-1-mmakassikis@freebox.fr,
        16235715.3469969-1-mmakassikis@freebox.fr,
        15130222.2976760-1-mmakassikis@freebox.fr,
        joe.keller@futurenet.com, luke.filipowicz@futurenet.com
Date:   29 Nov 2021 14:58:50 -0500
Subject: Fat Removes and Protein Bars
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q29tbWVudHM6DQpIZXksDQripLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXi
pLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXi
pLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXi
pLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXipLXi
pLXipLXipLXipLXipLXipLXipLXipLXipLUNCkFmcmljYW4gTWFuZ28gaXMgYSB3ZWln
aHQgbG9zcyBzdXBwbGVtZW50IHRoYXQgYnVybnMgZmF0LCBzdXBwcmVzc2VzDQpodW5n
ZXIgYW5kIGNyYXZpbmdzLCBhbmQgaGVscHMgbWFpbnRhaW4gaGVhbHRoeSBjaG9sZXN0
ZXJvbCBsZXZlbHMuIEl0cw0KdW5pcXVlIGZvcm11bGF0aW9uIGlzIGJhc2VkIG9uIGEg
bmF0dXJhbCBtb2xlY3VsZSBjYWxsZWQgcGFsbWl0b2xlaWMNCmFjaWQsIGFsc28ga25v
d24gYXMgT21lZ2EgNy4gVGhpcyB1bmlxdWUgZmF0dHkgYWNpZCBoZWxwcyBmYXQgY2Vs
bHMNCmNvbW11bmljYXRlIHdpdGggZWFjaCBvdGhlciwgZm9yY2luZyDigJxiYWQgZmF0
4oCdIGluIHRoZSBib2R5IHRvIGJlDQpyZWxlYXNlZCBhbmQgdXNlZCBmb3IgZW5lcmd5
LiBXaGljaCBtZWFucyBldmVuIGFzIHlvdSBzdGFydCBkcm9wcGluZw0KdGhvc2Ugc3R1
YmJvcm4gcG91bmRzLCB5b3XigJlyZSBnb2luZyB0byBmZWVsIGdyZWF0IGFuZCBmdWxs
IG9mIGVuZXJneSBhcw0KZmF0IHRoYXTigJlzIHJlbGVhc2VkIGZyb20geW91ciBjZWxs
cyBnZXQgY29udmVydGVkIGludG8gZnVlbCBmb3IgeW91cg0KYm9keS4gPj4+PiBodHRw
czovL2N1dHQubHkvM1Q4WjdNeA0K4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1DQpOdXZpYUdvIGlzIGEgZGVsaWNp
b3VzIHByb3RlaW4gYmFyIHdpdGggYSBjb29raWUgYW5kIGNyZWFtIGZsYXZvciBsb3Zl
ZA0KYWxsIG92ZXIgdGhlIHdvcmxkISBEdWUgdG8gdGhlIGxhcmdlIGRvc2Ugb2YgcHJv
dGVpbiBhbmQgYSBzbWFsbCBhbW91bnQNCm9mIHN1Z2FyLCB0aGlzIHByb2R1Y3QgY2Fu
IHJlcGxhY2UgYW55IG1lYWwuIE51dmlhR28gcHJvdmlkZXMgdGhlIGJvZHkNCndpdGgg
YW4gZW5lcmd5IGJvb3N0LCBoZWxwcyBidWlsZCBtdXNjbGUgbWFzcyBhbmQgYWNjZWxl
cmF0ZXMgcmVjb3ZlcnkNCmFmdGVyIHRyYWluaW5nLiBOdXZpYUdvIGJhcnMgYXJlIGNy
ZWF0ZWQgd2l0aCBwYXNzaW9uIGFuZCBpbiBoYXJtb255DQp3aXRoIG5hdHVyZS4gVGhp
cyBwcm9kdWN0IGNvbnRhaW5zIHRoZSByaWdodCBwcm9wb3J0aW9ucyBvZg0KbWFjcm9u
dXRyaWVudHMgdG8gc3RyZW5ndGhlbiB0aGUgYm9keSBhbmQgaGVscCBtYWludGFpbiBh
IGZpdC1maWd1cmUuDQpOdXZpYUdvIGJhcnMgYXJlIG5vdCBvbmx5IGEgZGVsaWNpb3Vz
LCBzd2VldCBzbmFjaywgYnV0IGFib3ZlIGFsbCBhDQpyZWFsLCB3aG9sZXNvbWUgbWVh
bCE+Pj4gaHR0cHM6Ly9jdXR0Lmx5L2tUOFhLZkUNCuKkteKkteKkteKkteKkteKkteKk
teKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKk
teKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKk
teKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKk
teKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKkteKktQ0KUmVnYXJkcw0K
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS14qS1
4qS14qS14qS1DQpKdWxpYQ0KICBfX19fXyAgDQoNCg0KUmVjb3JkOiAxDQoNClRpdGxl
OglUbyB0aGUgQXV0aG9yIG9mIHRoZSBORVcgQU1FUklDQU4gTUFHQVpJTkUuIAkNCg0K
U291cmNlOglOZXcgQW1lcmljYW4gTWFnYXppbmUuIE1hcjE3NjAsIElzc3VlIDI3LCBw
ODctODguIDJwLiAJDQoNClB1YmxpY2F0aW9uIFR5cGU6CVBlcmlvZGljYWwJDQoNCkRv
Y3VtZW50IFR5cGU6CUxldHRlcgkNCg0KU3ViamVjdHM6CUxFVFRFUlMgdG8gdGhlIGVk
aXRvcg0KUFNZQ0hPTE9HSUNBTCBzdHJlc3MJDQoNCkFjY2Vzc2lvbiBOdW1iZXI6CTM0
ODQxMDM0CQ0KDQpQZXJzaXN0ZW50IGxpbmsgdG8gdGhpcyByZWNvcmQgKFBlcm1hbGlu
ayk6IA0KaHR0cHM6Ly9zZWFyY2guZWJzY29ob3N0LmNvbS9sb2dpbi5hc3B4P2RpcmVj
dD10cnVlJmRiPWg5aCZBTj0zNDg0MTAzNCZzDQppdGU9ZWhvc3QtbGl2ZQ0KQ3V0IGFu
ZCBQYXN0ZTogPGENCmhyZWY9Imh0dHBzOi8vc2VhcmNoLmVic2NvaG9zdC5jb20vbG9n
aW4uYXNweD9kaXJlY3Q9dHJ1ZSZkYj1oOWgmQU49MzQ4NA0KMTAzNCZzaXRlPWVob3N0
LWxpdmUiPlRvIHRoZSBBdXRob3Igb2YgdGhlIE5FVyBBTUVSSUNBTiBNQUdBWklORS48
L2E+DQoNCiAgX19fX18gIA0KDQpUaGUgbGluayBpbmZvcm1hdGlvbiBhYm92ZSBwcm92
aWRlcyBhIHBlcnNpc3RlbnQgbGluayB0byB0aGUgYXJ0aWNsZQ0KeW91J3ZlIHJlcXVl
c3RlZC4NCg0KUGVyc2lzdGVudCBsaW5rIHRvIHRoaXMgcmVjb3JkOiBGb2xsb3dpbmcg
dGhlIGxpbmsgYWJvdmUgd2lsbCBicmluZyB5b3UNCnRvIHRoZSBzdGFydCBvZiB0aGUg
YXJ0aWNsZSBvciBjaXRhdGlvbi4NCg0KQ3V0IGFuZCBQYXN0ZTogVG8gcGxhY2UgYXJ0
aWNsZSBsaW5rcyBpbiBhbiBleHRlcm5hbCB3ZWIgZG9jdW1lbnQsDQpzaW1wbHkgY29w
eSBhbmQgcGFzdGUgdGhlIEhUTUwgYWJvdmUsIHN0YXJ0aW5nIHdpdGggIjxhIGhyZWYi
DQoNCklmIHlvdSBoYXZlIGFueSBwcm9ibGVtcyBvciBxdWVzdGlvbnMsIGNvbnRhY3Qg
VGVjaG5pY2FsIFN1cHBvcnQgYXQNCmh0dHA6Ly9zdXBwb3J0LmVwbmV0LmNvbS9jb250
YWN0L2Fza3VzLnBocCBvciBjYWxsIDgwMC03NTgtNTk5NS4NCg0KVGhpcyBlLW1haWwg
d2FzIGdlbmVyYXRlZCBieSBhIHVzZXIgb2YgRUJTQ09ob3N0IHdobyBnYWluZWQgYWNj
ZXNzIHZpYQ0KdGhlIE1JTklURVggTElCUkFSWSBJTkZPIE5FVFdPUksgYWNjb3VudC4g
TmVpdGhlciBFQlNDTyBub3IgTUlOSVRFWA0KTElCUkFSWSBJTkZPIE5FVFdPUksgaXMg
cmVzcG9uc2libGUgZm9yIHRoZSBjb250ZW50IG9mIHRoaXMgZS1tYWlsLg0K

